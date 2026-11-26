# Attenuator Console

[![Download ZIP](https://img.shields.io/badge/⬇_Download-AttenuatorConsole.zip-2ea44f?style=for-the-badge)](https://github.com/bangbeoo/attctrl/releases/latest/download/AttenuatorConsole.zip)
&nbsp;[All releases](https://github.com/bangbeoo/attctrl/releases)

**Quick start:** download the ZIP → extract → double-click **`Start Attenuator Console.bat`** (opens in Chrome/Edge).
**Bắt đầu nhanh:** tải ZIP → giải nén → nhấp đúp **`Start Attenuator Console.bat`** (mở bằng Chrome/Edge).

Web app chạy local (một file HTML duy nhất) để điều khiển nhiều **Attenuator Control Module (ACM)** qua cổng COM, mỗi cổng COM một thiết bị.

Giao diện song ngữ **English (mặc định) / Tiếng Việt**: chuyển bằng nút **EN | VI** trên thanh trên cùng.

## Yêu cầu
- **Google Chrome** hoặc **Microsoft Edge** (phiên bản 89 trở lên), vì app dùng Web Serial API. Firefox/Safari không hỗ trợ.
- Cáp serial 1:1, D-sub 9 chân (RXD, TXD, GND), hoặc bộ chuyển USB–RS232.

## Chạy
Nhấp đúp **`Start Attenuator Console.bat`**: app mở trong cửa sổ riêng của Chrome (nếu có) hoặc Edge. Cũng có thể mở trực tiếp `index.html` bằng Chrome/Edge. Không cần cài đặt hay chạy server.

## Phát hành bản mới
Mỗi lần push lên `main`, GitHub Actions đọc số phiên bản trong `index.html` (`<small>v0.6</small>`), đóng gói `AttenuatorConsole.zip` và đưa lên Release cùng tên:
- **Đổi số phiên bản** (ví dụ `v0.7`) → tạo Release mới, nút Download ở trên tự trỏ tới bản mới nhất.
- **Giữ nguyên số phiên bản** → chỉ thay file ZIP của Release hiện tại.

Lần đầu trên mỗi máy, ở ô **COM port** của từng thiết bị chọn **"➕ Add new port…"** (VI: "➕ Thêm cổng mới…") rồi chọn đúng COMx trong hộp thoại của trình duyệt. Trình duyệt sẽ nhớ quyền truy cập cho những lần sau.

> Web Serial không cho trang web đọc tên `COMx`, nên app nhận diện cổng bằng USB VID:PID và số thứ tự (ví dụ `0403:6001#0`). Tên COM thật chỉ hiện trong hộp thoại chọn cổng.

## Giao diện
- **Ngôn ngữ:** EN | VI. Mặc định là English; lựa chọn được lưu vào file XML.
- **Bố cục:** Toàn màn hình / 1/2 / **1/3 (mặc định, 3 trạm)** / 1/4. Nút ⛶ phóng to tạm một trạm.
- **＋ Thêm thiết bị:** thêm trạm, số lượng tùy ý.
- **Mỗi trạm có:**
  - Trạng thái **READY / BUSY / ĐANG ĐỒNG BỘ / KHÔNG PHẢN HỒI**.
  - Vị trí hiện tại kèm thông báo "Đã đến vị trí".
  - Truyền qua (%), năng lượng trung bình, năng lượng tham chiếu.
  - Thanh kéo dọc: thả chuột mới gửi lệnh.
  - Nút vị trí đặt sẵn: 🔴 **MAXIMUM** (nhấp nháy khi ở vị trí), 🟢 **PRODUCTION / SẢN XUẤT** (nhấp nháy khi ở vị trí), 🔵 **ALIGNMENT / CHỈNH TIA** (sáng liền khi ở vị trí). Mỗi nút có ô nhập steps.
  - Nút − / + theo bước, ô nhập vị trí + GO.
  - Log TX/RX, ô gửi lệnh tự do, xuất log ra file .txt.
- **⚙ (mỗi trạm):** thông số cổng, giới hạn an toàn min/max (mặc định 425…8000), lệnh **HOME** (bảo trì, có hỏi xác nhận trước khi gửi).
- **⌨ Giao thức:** sửa command và chu kỳ polling (dùng chung cho mọi trạm).
- **Demo:** mô phỏng thiết bị, dùng để thử giao diện khi không có phần cứng.
- **Chế độ Automatic:** đang phát triển (cần phần cứng đo năng lượng).

## Giao thức ACM
9600 bps, 8 data bits, 1 stop bit, parity OFF, không handshake, chế độ simplex. Ký tự kết thúc lệnh là `<CR>`. Phản hồi là giá trị trần, không kèm đơn vị hay tên lệnh.

| Lệnh | Ý nghĩa | Khi nào app gửi |
|---|---|---|
| `STAT?` | `READY` / `BUSY` | khi kết nối + mỗi 500 ms |
| `POS?` | vị trí (steps) | khi kết nối + mỗi 500 ms |
| `TRA?` | truyền qua (đơn vị 0.1 %) | khi kết nối + mỗi 500 ms |
| `EGY?` | năng lượng trung bình | khi kết nối + mỗi 2 s |
| `REF?` | năng lượng tham chiếu | khi kết nối + mỗi 2 s |
| `AVE?`, `CYC?`, `STATR?` | số lần lấy TB, thời gian tích phân, loop-control | khi kết nối / bấm vào dòng thông tin |
| `POS=xxxx` | đặt vị trí (không phản hồi) | khi bấm nút / kéo thanh / GO |
| `HOME` | về vị trí tham chiếu 50 % (không phản hồi) | chỉ khi bấm trong ⚙ → Bảo trì |

Vì phản hồi không có tiền tố, app gửi **từng lệnh một**: gửi lệnh → chờ một dòng trả lời (tối đa 400 ms) → gán dòng đó cho lệnh vừa gửi → gửi lệnh tiếp theo.

"Đã đến vị trí" được xác định khi `POS?` đọc lại đúng bằng giá trị đã gửi bằng `POS=`. Nếu sau 30 s vẫn chưa đến, app ghi cảnh báo vào log.

## Cấu hình (XML)
- **💾 Save XML** / **📂 Open XML** (Ctrl+S để lưu nhanh). App cũng tự lưu cấu hình gần nhất trong trình duyệt.
- File cấu hình chứa: ngôn ngữ (`language="en"` hoặc `"vi"`), bố cục, giao thức, danh sách trạm (tên, cổng, thông số cổng, giới hạn, bước, các vị trí đặt sẵn).
- File mẫu: [`config.example.xml`](config.example.xml).
