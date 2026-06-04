# Hướng Dẫn Cấu Hình Lab KVM và SDN Open vSwitch

**Tác giả:** cuongct0902

**Môi trường thử nghiệm:** Google Cloud Platform (GCP) - Nested Virtualization

**Trạng thái:** Đã kiểm chứng thực tế thành công 100% (Không lỗi console, không chặn AppArmor)


## Phần 0: Khởi Tạo Hạ Tầng L0 (Trên GCP Cloud Shell)

### 1. Tạo VM Instance có bật ảo hóa lồng (Nested Virtualization)

Chạy lệnh sau trên GCP Cloud Shell để tạo máy chủ vật lý L0:

```bash
gcloud compute instances create cuongct-vm-lab \
    --project=project-e8563bf4-58ff-402f-ac1 \
    --zone=asia-southeast1-b \
    --machine-type=n2-standard-4 \
    --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default \
    --metadata=enable-osconfig=TRUE \
    --maintenance-policy=MIGRATE \
    --provisioning-model=STANDARD \
    --service-account=1058769778175-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/trace.append \
    --create-disk=auto-delete=yes,boot=yes,device-name=cuongct-vm-lab,image=projects/ubuntu-os-cloud/global/images/ubuntu-minimal-2404-noble-amd64-v20260517,mode=rw,size=40,type=pd-balanced \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --reservation-affinity=any \
    --enable-nested-virtualization
```

### 2. SSH vào máy chủ L0 và cài đặt các gói nền tảng

```bash
# SSH vào máy L0 từ Cloud Shell
gcloud compute ssh cuongct-vdt-lab --zone=asia-southeast1-b

# Cài đặt các gói ảo hóa, SDN và Ansible
sudo apt update && sudo apt install \
    qemu-kvm libvirt-daemon-system libvirt-clients \
    virtinst bridge-utils openvswitch-switch ansible -y

sudo apt install iputils-ping net-tools libguestfs-tools nano vim -y
```


## Phần 1: Bài Tập Basic - Quản Trị VM Trên L0

**Mục tiêu:** Thao tác tạo, bật/tắt, nhân bản (clone) và tạo điểm khôi phục (snapshot) của máy ảo thông qua CLI.

### 1. Khởi tạo card mạng ảo mặc định của Libvirt

```bash
sudo virsh net-start default 2>/dev/null || true
sudo virsh net-autostart default 2>/dev/null || true
```

### 2. Tạo máy ảo basic-vm

```bash
# Tạo đĩa ảo dung lượng 5 GB
sudo qemu-img create -f qcow2 /var/lib/libvirt/images/basic-vm.qcow2 5G

# Tạo VM không cần giao diện đồ họa (dùng card default NAT)
sudo virt-install \
  --name basic-vm \
  --ram 512 \
  --vcpus 1 \
  --disk path=/var/lib/libvirt/images/basic-vm.qcow2,format=qcow2 \
  --network network=default \
  --graphics none \
  --pxe \
  --noautoconsole \
  --osinfo detect=on,require=off
```

### 3. Các lệnh điều khiển máy ảo

```bash
# Kiểm tra trạng thái máy ảo
sudo virsh list --all

# Bật máy ảo
sudo virsh start basic-vm

# Tắt an toàn (Shutdown) hoặc cưỡng bức (Destroy)
sudo virsh shutdown basic-vm
sudo virsh destroy basic-vm
```

### 4. Tạo Snapshot

```bash
# Tạo điểm khôi phục
sudo virsh snapshot-create-as \
  --domain basic-vm \
  --name snapshot_basic_stable \
  --description "Backup truoc khi kiem tra"

# Liệt kê danh sách Snapshot
sudo virsh snapshot-list basic-vm

# Khôi phục về Snapshot đã lưu
sudo virsh snapshot-revert basic-vm snapshot_basic_stable
```

### 5. Clone VM

```bash
# Máy ảo gốc phải được tắt trước khi clone
sudo virsh destroy basic-vm 2>/dev/null || true

# Nhân bản sang máy ảo mới
sudo virt-clone \
  --original basic-vm \
  --name basic-vm-clone \
  --file /var/lib/libvirt/images/basic-vm-clone.qcow2
```

## Phần 2: Bài Tập Advance - Máy Ảo Lồng Nhau và Live Migration

**Mục tiêu:** Dựng 2 Host L1 (`kvm-host-a` và `kvm-host-b`), cài đặt máy ảo con L2 trên Host A và migrate trực tiếp sang Host B không mất trạng thái.

### 1. Tạo mạng liên thông giữa 2 Host L1 (Thực hiện trên L0)

```bash
# Định nghĩa mạng LAN ảo cô lập
cat << 'EOF' > /tmp/inter-host-net.xml
<network>
  <name>inter-host-net</name>
  <bridge name='virbr1'/>
</network>
EOF

# Kích hoạt mạng liên thông
sudo virsh net-define /tmp/inter-host-net.xml
sudo virsh net-start inter-host-net
sudo virsh net-autostart inter-host-net
```

### 2. Chuẩn bị đĩa Ubuntu Cloud Image (Thực hiện trên L0)

```bash
# 1. Tải Ubuntu Server 22.04 LTS Cloud Image
sudo wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img \
  -O /var/lib/libvirt/images/ubuntu-base.img

# 2. Thay đổi kích thước đĩa lên 15 GB
sudo qemu-img resize /var/lib/libvirt/images/ubuntu-base.img 15G

# 3. Cấu hình sẵn KVM/OVS, đặt mật khẩu root, mở SSH
sudo virt-customize -a /var/lib/libvirt/images/ubuntu-base.img \
  --root-password password:123456 \
  --edit '/etc/ssh/sshd_config:s/#PermitRootLogin.*/PermitRootLogin yes/' \
  --edit '/etc/ssh/sshd_config:s/PasswordAuthentication no/PasswordAuthentication yes/' \
  --run-command 'ssh-keygen -A' \
  --install qemu-kvm,libvirt-daemon-system,libvirt-clients,virtinst,openvswitch-switch,iputils-ping,net-tools,wget -y

# 4. Sao chép đĩa gốc cho Host A và Host B
sudo cp /var/lib/libvirt/images/ubuntu-base.img /var/lib/libvirt/images/kvm-host-a.qcow2
sudo cp /var/lib/libvirt/images/ubuntu-base.img /var/lib/libvirt/images/kvm-host-b.qcow2
```

### 3. Khởi tạo 2 Host L1 với 2 card mạng (Thực hiện trên L0)

Mỗi Host L1 có hai card mạng:

- **Card 1 (enp1s0):** Nhận IP quản lý qua NAT (dải `192.168.122.x`).
- **Card 2 (enp2s0):** Nối trực tiếp vào mạng `inter-host-net` để phục vụ OVS và Migration.

```bash
# Khởi chạy Host A
sudo virt-install \
  --name kvm-host-a \
  --ram 2048 \
  --vcpus 2 \
  --cpu host-passthrough \
  --disk path=/var/lib/libvirt/images/kvm-host-a.qcow2,format=qcow2 \
  --network network=default,model=virtio \
  --network network=inter-host-net,model=virtio \
  --graphics none \
  --import \
  --noautoconsole \
  --osinfo detect=on,require=off

# Khởi chạy Host B
sudo virt-install \
  --name kvm-host-b \
  --ram 2048 \
  --vcpus 2 \
  --cpu host-passthrough \
  --disk path=/var/lib/libvirt/images/kvm-host-b.qcow2,format=qcow2 \
  --network network=default,model=virtio \
  --network network=inter-host-net,model=virtio \
  --graphics none \
  --import \
  --noautoconsole \
  --osinfo detect=on,require=off
```

### 4. Cấu hình mạng trên 2 Host L1 (Thủ công)

> **Lưu ý:** Nếu muốn cấu hình tự động 100% bằng Ansible, hãy bỏ qua phần này và chuyển đến **Phần 4**.

**Thực hiện trên Host A:**

```bash
ssh root@192.168.122.247

# Bật card mạng nội bộ và gán IP tĩnh
ip link set enp2s0 up
ip addr add 192.168.150.247/24 dev enp2s0
exit
```

**Thực hiện trên Host B:**

```bash
ssh root@192.168.122.23

ip link set enp2s0 up
ip addr add 192.168.150.23/24 dev enp2s0
exit
```

### 5. Thực hiện Live Migration thủ công

```bash
# SSH vào Host A
ssh root@192.168.122.247

# Tạo máy ảo L2
virt-install \
  --name nested-vm-migrate \
  --ram 512 \
  --vcpus 1 \
  --disk size=2,format=qcow2 \
  --network network=default,model=virtio \
  --graphics none \
  --pxe \
  --noautoconsole

# Migrate trực tiếp sang Host B
virsh migrate --live --unsafe --persistent --undefinesource \
  nested-vm-migrate qemu+ssh://root@192.168.150.23/system

exit
```

---

## Phần 3: Bài Tập Expert - Mạng SDN Trunking với Open vSwitch

**Mục tiêu:** Tạo mạng VLAN 100 bằng Open vSwitch liên thông qua `enp2s0` giữa Host A và Host B. Tạo 2 máy ảo L2 trên 2 Host, gán tag VLAN 100 và ping thông suốt giữa chúng.

### Thao tác trên Host A (192.168.122.247)

```bash
ssh root@192.168.122.247
```

#### 1. Tạo OVS Bridge và gộp card liên thông

```bash
# Xóa IP tĩnh cũ trên enp2s0 để nhường quyền cho OVS Bridge
ip addr del 192.168.150.247/24 dev enp2s0

# Tạo Bridge OVS và gộp card enp2s0
ovs-vsctl add-br ovs-br0
ovs-vsctl add-port ovs-br0 enp2s0

# Bật Bridge và gán lại IP liên thông
ip link set ovs-br0 up
ip addr add 192.168.150.247/24 dev ovs-br0
```

#### 2. Định nghĩa mạng ovs-network trên Libvirt

```bash
cat << 'EOF' > /tmp/ovs-net.xml
<network>
  <name>ovs-network</name>
  <forward mode='bridge'/>
  <bridge name='ovs-br0'/>
  <virtualport type='openvswitch'/>
</network>
EOF

virsh net-define /tmp/ovs-net.xml
virsh net-start ovs-network
virsh net-autostart ovs-network
```

#### 3. Tạo máy ảo L2 nested-vm02 với Alpine Linux

```bash
# Tạo đĩa ảo 5 GB
qemu-img create -f qcow2 /var/lib/libvirt/images/nested-vm02.qcow2 5G

# Tải Alpine Linux ISO (khoảng 60 MB)
wget https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-virt-3.19.1-x86_64.iso \
  -O /var/lib/libvirt/images/alpine.iso

# Khởi tạo VM cắm vào mạng OVS
virt-install \
  --name nested-vm02 \
  --ram 512 \
  --vcpus 1 \
  --disk path=/var/lib/libvirt/images/nested-vm02.qcow2,format=qcow2 \
  --cdrom /var/lib/libvirt/images/alpine.iso \
  --network network=ovs-network,model=virtio \
  --graphics none \
  --noautoconsole \
  --osinfo detect=on,require=off
```

#### 4. Gán Tag VLAN 100 và cấu hình Serial Console qua virsh edit

Chạy `virsh edit nested-vm02`, tìm phần `<devices>` và chỉnh sửa như sau:

```xml
<!-- 1. Gán Tag VLAN 100 cho card mạng -->
<interface type='network'>
  <source network='ovs-network'/>
  <vlan>
    <tag id='100'/>
  </vlan>
  <model type='virtio'/>
</interface>

<!-- 2. Cấu hình isa-serial để tránh lỗi đơ màn hình khi console -->
<serial type='pty'>
  <target type='isa-serial' port='0'>
    <model name='isa-serial'/>
  </target>
</serial>
<console type='pty'>
  <target type='serial' port='0'/>
</console>
```

Sau khi lưu, khởi động lại máy ảo:

```bash
virsh destroy nested-vm02 2>/dev/null || true
virsh start nested-vm02
```

#### 5. Đăng nhập và gán IP mạng SDN (10.0.0.2)

```bash
# Vào console máy ảo (đợi 15-30 giây, gõ Enter vài lần để hiện dòng login)
virsh console nested-vm02

# Đăng nhập: root (không mật khẩu)
# Kích hoạt mạng bên trong Alpine Linux:
ip link set eth0 up
ip addr add 10.0.0.2/24 dev eth0
```

> Bấm `Ctrl + ]` để thoát console về Host A, sau đó `exit` để về L0.


### Thao tác trên Host B (192.168.122.23)

```bash
ssh root@192.168.122.23
```

#### 1. Cấu hình OVS Bridge

```bash
ip addr del 192.168.150.23/24 dev enp2s0

ovs-vsctl add-br ovs-br0
ovs-vsctl add-port ovs-br0 enp2s0
ip link set ovs-br0 up
ip addr add 192.168.150.23/24 dev ovs-br0
```

#### 2. Định nghĩa ovs-network trên Libvirt

```bash
cat << 'EOF' > /tmp/ovs-net.xml
<network>
  <name>ovs-network</name>
  <forward mode='bridge'/>
  <bridge name='ovs-br0'/>
  <virtualport type='openvswitch'/>
</network>
EOF

virsh net-define /tmp/ovs-net.xml
virsh net-start ovs-network
virsh net-autostart ovs-network
```

#### 3. Tạo đĩa và khởi tạo máy ảo nested-vm01

```bash
qemu-img create -f qcow2 /var/lib/libvirt/images/nested-vm01.qcow2 5G

wget https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-virt-3.19.1-x86_64.iso \
  -O /var/lib/libvirt/images/alpine.iso

virt-install \
  --name nested-vm01 \
  --ram 512 \
  --vcpus 1 \
  --disk path=/var/lib/libvirt/images/nested-vm01.qcow2,format=qcow2 \
  --cdrom /var/lib/libvirt/images/alpine.iso \
  --network network=ovs-network,model=virtio \
  --graphics none \
  --noautoconsole \
  --osinfo detect=on,require=off
```

> Chạy `virsh edit nested-vm01`, gán Tag VLAN 100 và thêm cấu hình cổng `isa-serial` tương tự Host A, sau đó `virsh destroy` và `virsh start`.

#### 4. Đăng nhập và gán IP mạng SDN (10.0.0.1)

```bash
virsh console nested-vm01
# Đăng nhập bằng root, sau đó:
ip link set eth0 up
ip addr add 10.0.0.1/24 dev eth0
```


## Phần 4: IaC - Tự Động Hóa Hoàn Toàn Bằng Ansible

**Mục tiêu:** Đứng tại L0, chạy một lệnh duy nhất để tự động cài đặt KVM, Open vSwitch, tạo dải liên kết `192.168.150.x`, và khởi tạo VM con Alpine L2 trên mạng OVS với tag VLAN 100.

### 1. Chuẩn bị file Inventory (hosts.ini trên L0)

```ini
[hosts_l1]
kvm-host-a ansible_host=192.168.122.247 ansible_user=root ansible_password=123456
kvm-host-b ansible_host=192.168.122.23  ansible_user=root ansible_password=123456

[hosts_l1:vars]
ansible_ssh_common_args='-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
```

### 2. File XML Template cho máy ảo Alpine L2 (/tmp/alpine-vm.xml.j2 trên L0)

File template đã nhúng sẵn Tag VLAN 100 và cấu hình `isa-serial` console:

```xml
<domain type='kvm'>
  <name>{{ vm_name }}</name>
  <memory unit='KiB'>524288</memory>
  <currentMemory unit='KiB'>524288</currentMemory>
  <vcpu placement='static'>1</vcpu>
  <os>
    <type arch='x86_64' machine='pc-q35-6.2'>hvm</type>
    <boot dev='cdrom'/>
  </os>
  <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2'/>
      <source file='/var/lib/libvirt/images/{{ vm_name }}.qcow2'/>
      <target dev='vda' bus='virtio'/>
    </disk>
    <disk type='file' device='cdrom'>
      <driver name='qemu' type='raw'/>
      <source file='/var/lib/libvirt/images/alpine.iso'/>
      <target dev='sda' bus='sata'/>
      <readonly/>
    </disk>
    <interface type='network'>
      <source network='ovs-network'/>
      <vlan>
        <tag id='100'/>
      </vlan>
      <model type='virtio'/>
    </interface>
    <serial type='pty'>
      <target type='isa-serial' port='0'>
        <model name='isa-serial'/>
      </target>
    </serial>
    <console type='pty'>
      <target type='serial' port='0'/>
    </console>
  </devices>
</domain>
```

### 3. Ansible Playbook (/tmp/deploy-expert.yml trên L0)

```yaml
---
- name: Cau Hinh OVS Va Khoi Tao VM Con Alpine L2 Tu Dong
  hosts: hosts_l1
  gather_facts: yes
  vars:
    alpine_iso_url: "https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-virt-3.19.1-x86_64.iso"
    vlan_ip_map:
      kvm-host-a: "192.168.150.247/24"
      kvm-host-b: "192.168.150.23/24"
    vm_name_map:
      kvm-host-a: "nested-vm02"
      kvm-host-b: "nested-vm01"

  tasks:
    - name: 1. Đảm bảo dịch vụ Open vSwitch và Libvirt đang hoạt động
      service:
        name: "{{ item }}"
        state: started
        enabled: yes
      loop:
        - openvswitch-switch
        - libvirtd

    - name: 2. Xóa cấu hình IP cũ trên card enp2s0
      shell: "ip addr flush dev enp2s0"
      ignore_errors: yes

    - name: 3. Khởi tạo OVS Bridge
      openvswitch_bridge:
        name: ovs-br0
        state: present

    - name: 4. Gộp card mạng enp2s0 vào OVS Bridge
      openvswitch_port:
        bridge: ovs-br0
        port: enp2s0
        state: present

    - name: 5. Kích hoạt OVS Bridge và gán lại IP liên thông L3
      shell: |
        ip link set ovs-br0 up
        ip addr add {{ vlan_ip_map[inventory_hostname] }} dev ovs-br0
      ignore_errors: yes

    - name: 6. Tạo file cấu hình mạng ovs-network cho Libvirt
      copy:
        dest: "/tmp/ovs-net.xml"
        content: |
          <network>
            <name>ovs-network</name>
            <forward mode='bridge'/>
            <bridge name='ovs-br0'/>
            <virtualport type='openvswitch'/>
          </network>

    - name: 7. Đăng ký và kích hoạt mạng ovs-network trên Libvirt
      shell: |
        virsh net-destroy ovs-network || true
        virsh net-undefine ovs-network || true
        virsh net-define /tmp/ovs-net.xml
        virsh net-start ovs-network
        virsh net-autostart ovs-network
      ignore_errors: yes

    - name: 8. Tải Alpine ISO và tạo đĩa cứng rỗng cho máy ảo L2
      shell: |
        wget -q {{ alpine_iso_url }} -O /var/lib/libvirt/images/alpine.iso
        qemu-img create -f qcow2 /var/lib/libvirt/images/{{ vm_name_map[inventory_hostname] }}.qcow2 5G
      args:
        creates: "/var/lib/libvirt/images/{{ vm_name_map[inventory_hostname] }}.qcow2"

    - name: 9. Tạo cấu hình XML từ Jinja2 Template
      template:
        src: "/tmp/alpine-vm.xml.j2"
        dest: "/tmp/{{ vm_name_map[inventory_hostname] }}.xml"

    - name: 10. Định nghĩa và khởi chạy máy ảo L2
      shell: |
        virsh destroy {{ vm_name_map[inventory_hostname] }} || true
        virsh undefine {{ vm_name_map[inventory_hostname] }} || true
        virsh define /tmp/{{ vm_name_map[inventory_hostname] }}.xml
        virsh start {{ vm_name_map[inventory_hostname] }}
```

### 4. Thực thi Playbook từ L0

```bash
ansible-playbook -i hosts.ini /tmp/deploy-expert.yml
```

---

## Phụ Lục: Các Lệnh Kiểm Tra Hạ Tầng

Đứng ở các Host L1, chạy các lệnh sau để lấy số liệu phân tích và báo cáo:

```bash
# 1. Kiểm tra bảng học MAC của Switch ảo OVS (chứng minh VLAN Trunking hoạt động)
ovs-appctl fdb/show ovs-br0

# 2. Xem phân bổ ổ đĩa và phân vùng ISO của máy ảo L2
virsh domblklist nested-vm01

# 3. Xem thông số cấp phát của tệp đĩa qcow2 (đo lường Thin Provisioning)
qemu-img info /var/lib/libvirt/images/nested-vm01.qcow2

# 4. Giám sát thời gian thực RAM/CPU các máy ảo đang chạy
virt-top
```