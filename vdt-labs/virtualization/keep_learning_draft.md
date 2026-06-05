
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