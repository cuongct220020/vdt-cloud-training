## 🗺️ Giải pháp: Thiết kế 2 Subnet riêng biệt bằng 2 Mạng ảo Isolated

Thay vì cho cả 2 host L1 cắm chung vào mạng `migration-net` (chung một subnet `10.10.10.0/24`), bạn sẽ tạo ra **2 mạng ảo khác nhau** trên L0, đại diện cho 2 Subnet (hoặc 2 Site/Phòng máy) khác nhau:

* **Mạng `subnet-A` (cho Host L1-A):** Dải IP `10.10.10.0/24`
* **Mạng `subnet-B` (cho Host L1-B):** Dải IP `10.10.20.0/24`

---

## ⚠️ Lưu ý cốt lõi: Thách thức lớn đối với Live Migration (Bài Advance)

Việc chia 2 host L1 ra 2 subnet khác nhau mang lại tư duy thiết kế hệ thống rất tốt, nhưng nó sẽ dựng lên một "bức tường" kỹ thuật mà bạn cần phải xử lý ở bài **Advance** và **Expert**:

### 1. Ở bài Advance (Live Migration)

Như chúng ta đã thống nhất ở các câu trước, điều kiện tiên quyết của Live Migration là **2 host phải thông nhau**.

* Khi L1-A (`10.10.10.X`) muốn nói chuyện với L1-B (`10.10.20.X`), gói tin bắt buộc phải đi qua một thiết bị định tuyến (**Router/Gateway**).
* **Giải pháp:** Bản thân Linux Kernel của máy Host L0 (`cuongct-vdt-lab`) mặc định đã có tính năng định tuyến giữa các Linux Bridge ảo do Libvirt tạo ra, miễn là bạn bật tính năng IP Forwarding (`sysctl -w net.ipv4.ip_forward=1`). Máy L0 sẽ đóng vai trò là con Router đứng giữa trung chuyển gói tin giữa 2 subnet này. Bạn chỉ cần đảm bảo Firewall (`iptables`) trên L0 không chặn traffic giữa 2 mạng này là Live Migration vẫn chạy phăng phăng.

### 2. Ở bài Expert (Openvswitch & VLAN)

Đây mới là chỗ "hack não" thực sự. Đề bài Expert yêu cầu: *Tạo VLAN mạng trên 2 host, attach interface vlan vào 2 host và ping qua lại giữa 2 VM.*

* Bản chất của **VLAN (Virtual LAN)** là giao tiếp ở **Layer 2 (Cùng một dải mạng/Broadcast Domain)**.
* Nếu card mạng vật lý (hoặc mạng ảo kết nối giữa 2 host) nằm ở 2 subnet khác nhau thông qua một Router Layer 3, các gói tin gắn tag VLAN Layer 2 sẽ **không thể tự đi xuyên qua Router** theo cách thông thường được (Router sẽ bóc bỏ header Layer 2 bao gồm cả Tag VLAN).

> 💡 **Mẹo giải quyết của Cloud Engineer:** Nếu bạn vẫn muốn giữ cấu trúc 2 host ở 2 subnet khác nhau mà vẫn muốn hoàn thành bài Expert, người ta sẽ không dùng mạng VLAN thuần túy nữa mà phải dùng các giao thức **Overlay Network (Tunnels)** như **VXLAN** hoặc **GRE**. Các công nghệ này sẽ đóng gói gói tin Layer 2 của VM con vào bên trong một gói tin Layer 3 (UDP) để nó thoải mái "bay" xuyên qua Router giữa 2 subnet. Openvswitch hỗ trợ cực tốt cấu hình VXLAN này!

---

## 🛠️ Best Practice khuyến nghị cho riêng bài Lab của bạn:

Để cân bằng giữa **độ thực tế** và **độ phức tạp vừa phải** nhằm tránh bị "tẩu hỏa nhập ma" khi cấu hình:

1. **Mạng Quản trị/Dịch vụ (Management):** Bạn nên chia làm 2 Subnet riêng (`10.10.10.0/24` và `10.10.20.0/24`) như bạn kỳ vọng để mô phỏng thực tế 2 host nằm ở 2 vùng mạng khác nhau.
2. **Mạng dành riêng cho Openvswitch (Bài Expert):** Bạn vẫn nên tạo thêm 1 mạng ảo thứ 3 dạng **Isolated thuần túy (không cấp IP ở L0)** để làm đường Trunk Layer 2 cắm chung vào cả 2 host. Đường dây này đóng vai trò như một "sợi cáp quang nối trực tiếp" giữa 2 văn phòng (Direct Connect/Leased Line). Khi đó, bài Expert dùng OVS tạo VLAN sẽ chạy đúng chuẩn lý thuyết mà không cần cấu hình VXLAN phức tạp.

Bạn thấy phương án bắc thêm một "sợi cáp riêng Layer 2" song song với việc chia subnet quản trị này có giúp bạn vừa đạt được tính thực tế, vừa dễ thở hơn khi làm bài Expert không?