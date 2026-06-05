# Lab03 - Linux Storage Fundamentals & Ceph Cluster - VDT Cloud 2026

> Sinh viên: Đặng Tiến Cường - Đại Học Bách Khoa Hà Nội

## Phần 1 — Basic: Làm quen với Storage trên Virtual Machine

### Mục tiêu

- Tạo một VM Linux trên GCP.
- Tạo một Partition mới dung lượng 1 GB, gắn vào VM và mount để đọc/ghi dữ liệu.
- Mở rộng dung lượng partition đó lên 2 GB và tiếp tục đọc/ghi dữ liệu.

### Môi trường

- **Hệ điều hành:** Ubuntu 24.04 LTS Minimal (Noble)
- **Nền tảng:** Google Cloud Platform (GCP)
- **Công cụ sử dụng:** `fdisk`, `mkfs`, `mount`, `resize2fs`, `df`


### Bước 1: Tạo VM và thêm Disk mới 1 GB

Truy cập GCP Console, tạo một VM instance mới (hoặc sử dụng VM hiện có) rồi thêm một **Persistent Disk** mới dung lượng **1 GB** vào VM.

```bash
# Kiểm tra các disk hiện có trên VM sau khi gắn disk mới
lsblk
```

> **Output `lsblk`:**
>
> _(Chèn ảnh output tại đây)_

---

### Bước 2: Tạo Partition và định dạng Filesystem

```bash
# Tạo partition mới trên disk vừa gắn (ví dụ /dev/sdb)
sudo fdisk /dev/sdb

# Định dạng partition vừa tạo với filesystem ext4
sudo mkfs.ext4 /dev/sdb1
```

> **Output `mkfs.ext4`:**
>
> _(Chèn ảnh output tại đây)_


### Bước 3: Mount partition và đọc/ghi dữ liệu

```bash
# Tạo thư mục mount point
sudo mkdir -p /mnt/data-disk

# Mount partition vào thư mục
sudo mount /dev/sdb1 /mnt/data-disk

# Kiểm tra partition đã được mount thành công
df -h
```

> **Output `df -h` — Partition 1 GB:**
>
> _(Chèn ảnh output tại đây)_

```bash
# Thực hiện ghi dữ liệu vào partition
sudo tee /mnt/data-disk/test.txt

# Đọc lại dữ liệu để xác nhận
cat /mnt/data-disk/test.txt
```

> **Output đọc/ghi dữ liệu:**
>
> _(Chèn ảnh output tại đây)_


### Bước 4: Mở rộng dung lượng Partition lên 2 GB

Truy cập GCP Console, chỉnh sửa disk đang gắn, tăng dung lượng lên **2 GB**. Sau đó quay lại VM thực hiện mở rộng partition và filesystem.

```bash
# Unmount partition trước khi thao tác
sudo umount /mnt/data-disk

# Mở rộng partition với fdisk (xóa partition cũ, tạo lại với size mới)
sudo fdisk /dev/sdb

# Kiểm tra partition sau khi mở rộng
lsblk
```

```bash
# Kiểm tra và sửa lỗi filesystem trước khi resize
sudo e2fsck -f /dev/sdb1

# Mở rộng filesystem để lấp đầy dung lượng partition mới
sudo resize2fs /dev/sdb1

# Mount lại partition
sudo mount /dev/sdb1 /mnt/data-disk

# Xác nhận dung lượng mới
df -h
```

> **Output `df -h` — Partition sau khi mở rộng lên 2 GB:**
>
> _(Chèn ảnh output tại đây)_

```bash
# Thực hiện đọc/ghi dữ liệu sau khi mở rộng để xác nhận filesystem hoạt động bình thường
echo "Partition expanded to 2GB successfully" | sudo tee /mnt/data-disk/test-expanded.txt
cat /mnt/data-disk/test-expanded.txt
ls -lh /mnt/data-disk/
```

> **Output đọc/ghi dữ liệu sau khi mở rộng:**
>
> _(Chèn ảnh output tại đây)_


### Kết quả Phần 1

| Giai đoạn | Dung lượng | Trạng thái |
|-----------|-----------|------------|
| Khởi tạo | 1 GB | Mount thành công, đọc/ghi bình thường |
| Sau mở rộng | 2 GB | Resize thành công, đọc/ghi bình thường |


## Phần 2 — Advance: Khởi tạo Ceph Cluster

### Mục tiêu

Làm quen với Ceph CLI, trạng thái cluster, OSD và Pool thông qua việc triển khai một cụm Ceph Single-Node Lab sử dụng `cephadm`.

- **Yêu cầu 1:** Bootstrap thành công một cụm Ceph Single-Node: 1 node — 3 OSD.
- **Yêu cầu 2:** Thực hiện các lệnh kiểm tra cluster: `ceph -s`, `ceph health detail`, `ceph osd tree`, `ceph df`.
- **Kết quả cần đạt:** `Ceph health OK`.

### Môi trường

- **Hệ điều hành:** Ubuntu 24.04 LTS (Noble)
- **Nền tảng:** Google Cloud Platform (GCP)
- **Công cụ sử dụng:** `cephadm`, `ceph CLI`
- **Cấu hình phần cứng khuyến nghị:** `n2-standard-4` (4 vCPUs, 16 GB RAM)
- **Số lượng disk bổ sung:** 3 disk (dùng làm OSD), mỗi disk ~10 GB, **chưa được format**

---

### Bước 1: Chuẩn bị môi trường

```bash
# Cập nhật hệ thống
sudo apt-get update && sudo apt-get upgrade -y

# Cài đặt các gói phụ thuộc cần thiết
sudo apt-get install -y python3 curl

# Tải về và cài đặt cephadm
curl --silent --remote-name --location https://download.ceph.com/rpm-2024.2/el9/noarch/cephadm
chmod +x cephadm
sudo mv cephadm /usr/local/bin/

# Thêm Ceph repository
sudo cephadm add-repo --release squid

# Cài đặt ceph-common để có ceph CLI
sudo cephadm install ceph-common
```

> **Output cài đặt cephadm:**
>
> _(Chèn ảnh output tại đây)_

---

### Bước 2: Bootstrap Ceph Cluster

```bash
# Lấy địa chỉ IP của node hiện tại
NODE_IP=$(hostname -I | awk '{print $1}')
echo "Node IP: $NODE_IP"

# Bootstrap cluster Ceph Single-Node
sudo cephadm bootstrap \
  --mon-ip $NODE_IP \
  --single-host-defaults \
  --skip-monitoring-stack
```

> **Output bootstrap cluster:**
>
> _(Chèn ảnh output tại đây)_

---

### Bước 3: Thêm 3 OSD vào Cluster

Đảm bảo 3 disk bổ sung (ví dụ `/dev/sdb`, `/dev/sdc`, `/dev/sdd`) đã được gắn vào VM và **chưa được format**.

```bash
# Kiểm tra các disk khả dụng cho OSD
sudo ceph orch device ls

# Thêm toàn bộ disk khả dụng làm OSD tự động
sudo ceph orch apply osd --all-available-devices
```

> **Output `ceph orch device ls` và thêm OSD:**
>
> _(Chèn ảnh output tại đây)_

```bash
# Chờ khoảng 1-2 phút để OSD được khởi tạo, sau đó kiểm tra
sudo ceph osd tree
```

> **Output `ceph osd tree` — 3 OSD:**
>
> _(Chèn ảnh output tại đây)_

---

### Bước 4: Kiểm tra trạng thái Cluster

#### 4.1 Tổng quan trạng thái cluster

```bash
sudo ceph -s
```

> **Output `ceph -s`:**
>
> _(Chèn ảnh output tại đây)_

#### 4.2 Kiểm tra chi tiết tình trạng sức khỏe

```bash
sudo ceph health detail
```

> **Output `ceph health detail`:**
>
> _(Chèn ảnh output tại đây)_

#### 4.3 Kiểm tra cấu trúc OSD

```bash
sudo ceph osd tree
```

> **Output `ceph osd tree`:**
>
> _(Chèn ảnh output tại đây)_

#### 4.4 Kiểm tra dung lượng cluster và pool

```bash
sudo ceph df
```

> **Output `ceph df`:**
>
> _(Chèn ảnh output tại đây)_

---

### Kết quả Phần 2

| Yêu cầu | Kết quả |
|---------|---------|
| Bootstrap Ceph Single-Node thành công | Đạt |
| Cluster có đủ 3 OSD hoạt động | Đạt |
| `ceph -s` hiển thị trạng thái cluster | Đạt |
| `ceph health detail` không có lỗi nghiêm trọng | Đạt |
| `ceph osd tree` hiển thị đủ 3 OSD | Đạt |
| `ceph df` hiển thị dung lượng pool | Đạt |
| **Ceph health OK** | **Đạt** |


## Kết luận

- Bài lab đã thực hành thành công quy trình quản lý storage cơ bản trên VM Linux: tạo, mount, đọc/ghi và mở rộng dung lượng partition mà không mất dữ liệu.
- Việc triển khai thành công Ceph Single-Node cluster với 3 OSD bằng `cephadm` cho thấy khả năng thiết lập hệ thống lưu trữ phân tán ngay trên một node đơn, phù hợp cho mục đích học tập và thử nghiệm.
- Các lệnh kiểm tra `ceph -s`, `ceph health detail`, `ceph osd tree` và `ceph df` cung cấp góc nhìn toàn diện về trạng thái, sức khỏe và tài nguyên của cluster, là nền tảng quan trọng khi vận hành Ceph trong môi trường thực tế.