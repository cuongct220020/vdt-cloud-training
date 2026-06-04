```
cat << 'EOF' > setup_l1_hosts.yml
---
- name: "VDT 2026: Tự động hóa khởi tạo cấu trúc 2 Host L1 bằng Ansible (Cloud Image)"
  hosts: localhost
  become: true
  tasks:

    - name: "1. Kích hoạt tính năng Ảo hóa lồng nhau (Nested KVM) trên nhân Linux"
      shell: |
        if cat /sys/module/kvm_intel/parameters/nested | grep -q "N"; then
          modprobe -r kvm_intel
          modprobe kvm_intel nested=1
        fi
      ignore_errors: yes

    - name: "2. Định nghĩa mạng nội bộ cô lập (nested-mgmt) ở tầng L0"
      virt_net:
        name: nested-mgmt
        state: present
        xml: |
          <network>
            <name>nested-mgmt</name>
            <bridge name='virbr1' stp='on' delay='0'/>
          </network>

    - name: "3. Khởi động mạng nội bộ và cấu hình tự động bật"
      virt_net:
        name: nested-mgmt
        state: active
        autostart: yes

    - name: "4. Đảm bảo thư mục lưu trữ Libvirt tồn tại"
      file:
        path: /var/lib/libvirt/images
        state: directory
        mode: '0755'

    - name: "5. Tải bản đĩa ảo Ubuntu 22.04 Cloud Image chuẩn từ trang chủ"
      get_url:
        url: "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
        dest: /var/lib/libvirt/images/jammy-base.qcow2
        mode: '0644'

    # --- CẤU HÌNH VÀ KHỞI TẠO HOST A ---
    - name: "6. Kiểm tra xem kvm-host-a đã tồn tại chưa"
      command: virsh dominfo kvm-host-a
      register: host_a_check
      failed_when: false
      changed_when: false

    - name: "7. Tạo đĩa ảo riêng cho Host A từ đĩa gốc"
      copy:
        src: /var/lib/libvirt/images/jammy-base.qcow2
        dest: /var/lib/libvirt/images/kvm-host-a.qcow2
        remote_src: yes
      when: host_a_check.rc != 0

    - name: "8. Tăng dung lượng ổ đĩa Host A lên 20GB"
      command: qemu-img resize /var/lib/libvirt/images/kvm-host-a.qcow2 20G
      when: host_a_check.rc != 0

    - name: "9. Khởi chạy máy chủ Host A (L1) bằng cơ chế Import"
      command: >
        virt-install
        --name kvm-host-a
        --ram 4096
        --vcpus 2
        --disk path=/var/lib/libvirt/images/kvm-host-a.qcow2,format=qcow2
        --network network=default,model=virtio
        --network network=nested-mgmt,model=virtio
        --cpu host-passthrough
        --graphics none
        --os-variant ubuntu22.04
        --import
        --noautoconsole
      when: host_a_check.rc != 0

    # --- CẤU HÌNH VÀ KHỞI TẠO HOST B ---
    - name: "10. Kiểm tra xem kvm-host-b đã tồn tại chưa"
      command: virsh dominfo kvm-host-b
      register: host_b_check
      failed_when: false
      changed_when: false

    - name: "11. Tạo đĩa ảo riêng cho Host B từ đĩa gốc"
      copy:
        src: /var/lib/libvirt/images/jammy-base.qcow2
        dest: /var/lib/libvirt/images/kvm-host-b.qcow2
        remote_src: yes
      when: host_b_check.rc != 0

    - name: "12. Tăng dung lượng ổ đĩa Host B lên 20GB"
      command: qemu-img resize /var/lib/libvirt/images/kvm-host-b.qcow2 20G
      when: host_b_check.rc != 0

    - name: "13. Khởi chạy máy chủ Host B (L1) bằng cơ chế Import"
      command: >
        virt-install
        --name kvm-host-b
        --ram 4096
        --vcpus 2
        --disk path=/var/lib/libvirt/images/kvm-host-b.qcow2,format=qcow2
        --network network=default,model=virtio
        --network network=nested-mgmt,model=virtio
        --cpu host-passthrough
        --graphics none
        --os-variant ubuntu22.04
        --import
        --noautoconsole
      when: host_b_check.rc != 0
EOF

ansible-playbook -i hosts.ini setup_l1_hosts.yml
```