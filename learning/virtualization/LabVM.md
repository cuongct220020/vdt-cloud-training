## Lab 01 - 




```bash
gcloud compute instances create cuongct-vdt-lab \
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

# SSH vào VM instance vừa tạo
gcloud compute ssh cuongct-vdt-lab --zone=asia-southeast1-b

# Tải các gói cần thiết
sudo apt update && sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients virtinst bridge-utils openvswitch-switch -y
sudo apt update && sudo apt install iputils-ping net-tools -y
sudo apt update && sudo apt install libguestfs-tools -y
sudo apt update && sudo apt install -y nano vim


Bạn gõ lệnh nano hosts.ini và dán nội dung này vào:
[localhost]
127.0.0.1 ansible_connection=local



```