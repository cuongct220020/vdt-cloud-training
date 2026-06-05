# 🗺️ Bảng Quy Hoạch 3 Mạng Ảo (Best Practices)

| Tên Mạng Ảo | Chế độ (Mode) | Dải IP Gợi Ý | Vai Trò & Nhiệm Vụ Trong Bài Lab |
|------------|---------------|--------------|----------------------------------|
| `default` (Có sẵn) | NAT | `192.168.122.0/24` | **Management & Internet Network**: Dùng để SSH từ máy ngoài vào các Host L1, đồng thời cấp Internet cho các Host L1 để cài đặt gói dịch vụ (`apt install`, cập nhật hệ thống, tải package, v.v.). |
| `migration-net` (Tạo mới) | Isolated (Nội bộ) | `10.10.10.0/24` | **Storage & Migration Network (Bài Advance)**: Dùng riêng cho luồng truyền tải dữ liệu dung lượng lớn như NFS Storage và quá trình truyền trạng thái RAM khi thực hiện Live Migration, giúp tránh làm nghẽn mạng quản trị. |
| `ovs-trunk-net` (Tạo mới) | Isolated (Nội bộ) | Không cần cấp IP trên L0 | **Data/VLAN Network (Bài Expert)**: Mạng này đóng vai trò như một đường cáp vật lý (Trunk) nối giữa hai Host L1. Open vSwitch sẽ được cấu hình trên mạng này để vận chuyển các frame mang VLAN Tag giữa các VM L2 trên các host khác nhau. |

---

# 🛠️ Tại Sao Thiết Kế Này Được Xem Là Best Practice?

## 1. An toàn cho Live Migration (Bài Advance)

Khi thực hiện **Live Migration**, dữ liệu RAM của máy ảo được truyền qua mạng. Theo cấu hình mặc định, luồng dữ liệu này thường không được mã hóa.

Việc tách riêng một mạng chuyên dụng (`migration-net`) giúp:

- Cô lập lưu lượng migration khỏi mạng quản trị.
- Hạn chế nguy cơ nghe lén hoặc thu thập dữ liệu nhạy cảm.
- Tránh ảnh hưởng hiệu năng của các tác vụ quản trị như SSH hoặc API quản lý hypervisor.
- Mô phỏng đúng kiến trúc triển khai trong môi trường doanh nghiệp.

---

## 2. Chuẩn hóa hạ tầng cho Open vSwitch (Bài Expert)

Để triển khai VLAN xuyên suốt giữa hai Host L1 bằng Open vSwitch, đường kết nối giữa các host phải cho phép truyền tải các frame mang **802.1Q VLAN Tag**.

Nếu sử dụng mạng NAT hoặc mạng có thiết bị trung gian (router/firewall), các VLAN Tag có thể bị:

- Loại bỏ (strip).
- Chặn (drop).
- Thay đổi hành vi xử lý.

Do đó, việc tạo một mạng riêng `ovs-trunk-net` ở chế độ **Isolated** giúp:

- Hoạt động như một "sợi cáp mạng Layer 2 thuần túy".
- Không có router hoặc NAT can thiệp vào frame Ethernet.
- Cho phép toàn quyền cấu hình Open vSwitch.
- Mô phỏng chính xác mô hình Trunk Port trong môi trường vật lý.

---

# 🎯 Tóm Tắt Thiết Kế

```text
                 Internet
                     |
                     |
              default (NAT)
            192.168.122.0/24
                     |
        +------------+------------+
        |                         |
      Host L1-A               Host L1-B
        |                         |
        +------ migration-net ----+
        |       10.10.10.0/24     |
        |                         |
        +------ ovs-trunk-net ----+
                Layer-2 Trunk
             (Open vSwitch VLAN)