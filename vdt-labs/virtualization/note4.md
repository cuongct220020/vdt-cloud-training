2. Mô hình kết nối SSH chuẩn (Best Practice Topology)
Vì bạn đang làm ảo hóa lồng nhau (Nested), luồng đi của các kết nối SSH từ máy vật lý của bạn sẽ được chia làm 2 chặng:

[Máy cá nhân của bạn] 
       │ (Dành cho môi trường thực tế)
       ▼
[Máy ngoài cùng L0: cuongct-vdt-lab]
       │
       ├───────► SSH vào Host L1-A (IP: 192.168.122.X)
       ├───────► SSH vào Host L1-B (IP: 192.168.122.Y)
       │
       └───────► SSH vào VM con L2 (IP cấp bởi L1)
Cách triển khai cho VM L2 (Con của L1):
Mặc định, các VM con L2 nằm bên trong Host L1 sẽ nhận IP từ switch ảo do Host L1 quản lý.

Để đứng từ con máy L0 (cuongct-vdt-lab) có thể SSH thẳng vào con VM L2 mà không cần phải SSH "bắc cầu" qua L1, bạn chỉ cần đảm bảo Host L1 bật tính năng IP Forwarding (sysctl -w net.ipv4.ip_forward=1) và trên máy L0 bạn thêm một dòng định tuyến (Static Route) trỏ dải mạng của L2 về IP của L1.