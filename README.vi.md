# HỆ THỐNG QUẢN LÝ SÂN BAY (Airport Management System)

<p>
  <img src="https://img.shields.io/badge/Java-17%2B-orange" alt="Java">
  <img src="https://img.shields.io/badge/Spring%20MVC-6.x-brightgreen" alt="Spring MVC">
  <img src="https://img.shields.io/badge/Hibernate-6.x-blue" alt="Hibernate">
  <img src="https://img.shields.io/badge/MySQL-8.x-4479A1" alt="MySQL">
  <img src="https://img.shields.io/badge/Tomcat-10.x-yellow" alt="Tomcat 10">
</p>

## 1. Giới thiệu

Hệ thống quản lý sân bay được xây dựng nhằm quản lý:

- Chuyến bay
- Hành khách
- Vé máy bay
- Lịch sử thay đổi trạng thái chuyến bay

Mỗi hành khách có thể đặt nhiều vé máy bay cho các chuyến bay khác nhau. Mỗi chuyến bay có thể có nhiều hành khách đặt vé.

Hệ thống được phát triển bằng: Spring MVC (không sử dụng Spring Boot), Hibernate ORM, MySQL, JSP/JSTL, Apache Tomcat 10, Bootstrap 5, Font Awesome.

---

## 2. Công nghệ sử dụng

| Công nghệ    | Phiên bản |
| ------------ | --------- |
| Java         | 17+       |
| Spring MVC   | 6.x       |
| Hibernate    | 6.x       |
| MySQL        | 8.x       |
| JSP/JSTL     | Latest    |
| Maven        | Latest    |
| Tomcat       | 10.x      |
| Bootstrap    | 5.x       |
| Font Awesome | 6.x       |

---

## 3. Thiết kế cơ sở dữ liệu

### Bảng CHUYEN_BAY

| Cột             | Kiểu dữ liệu | Ràng buộc          |
| --------------- | ------------ | ------------------- |
| maChuyenBay     | INT          | PK, AUTO_INCREMENT  |
| soHieuChuyenBay | VARCHAR(20)  | NOT NULL             |
| ngayGioKhoiHanh | DATETIME     | NOT NULL              |
| ngayGioDen      | DATETIME     | NOT NULL               |
| diemKhoiHanh    | VARCHAR(100) | NOT NULL                |
| diemDen         | VARCHAR(100) | NOT NULL                 |
| trangThai       | VARCHAR(50)  | NOT NULL                  |

**Giá trị trạng thái:** `Đúng giờ`, `Hoãn`, `Hủy`, `Đổi lịch`

### Bảng HANH_KHACH

| Cột         | Kiểu dữ liệu | Ràng buộc          |
| ----------- | ------------ | ------------------- |
| maHanhKhach | INT          | PK, AUTO_INCREMENT  |
| hoTen       | VARCHAR(100) | NOT NULL             |
| soDienThoai | VARCHAR(10)  | NOT NULL              |
| email       | VARCHAR(100) | NOT NULL               |

### Bảng VE_MAY_BAY

| Cột         | Kiểu dữ liệu | Ràng buộc          |
| ----------- | ------------ | ------------------- |
| maVe        | INT          | PK, AUTO_INCREMENT  |
| maHanhKhach | INT          | FK                   |
| maChuyenBay | INT          | FK                    |
| loaiVe      | VARCHAR(50)  | NOT NULL               |
| giaVe       | BIGINT       | NOT NULL                |
| thongBao    | VARCHAR(255) |                           |

```sql
ALTER TABLE VE_MAY_BAY
ADD CONSTRAINT FK_VE_HANHKHACH
FOREIGN KEY(maHanhKhach)
REFERENCES HANH_KHACH(maHanhKhach);

ALTER TABLE VE_MAY_BAY
ADD CONSTRAINT FK_VE_CHUYENBAY
FOREIGN KEY(maChuyenBay)
REFERENCES CHUYEN_BAY(maChuyenBay);
```

### Bảng LICH_SU_CHUYEN_BAY

| Cột             | Kiểu dữ liệu | Ràng buộc          |
| --------------- | ------------ | ------------------- |
| maLichSu        | INT          | PK, AUTO_INCREMENT  |
| maChuyenBay     | INT          | FK                   |
| trangThaiCu     | VARCHAR(50)  |                       |
| trangThaiMoi    | VARCHAR(50)  |                        |
| thoiGianCapNhat | DATETIME     |                         |

---

## 4. Quan hệ dữ liệu Hibernate

**ChuyenBay Entity**
```java
@OneToMany(mappedBy = "chuyenBay")
private List<VeMayBay> danhSachVe;

@OneToMany(mappedBy = "chuyenBay")
private List<LichSuChuyenBay> lichSuList;
```

**HanhKhach Entity**
```java
@OneToMany(mappedBy = "hanhKhach")
private List<VeMayBay> danhSachVe;
```

**VeMayBay Entity**
```java
@ManyToOne
@JoinColumn(name = "maHanhKhach")
private HanhKhach hanhKhach;

@ManyToOne
@JoinColumn(name = "maChuyenBay")
private ChuyenBay chuyenBay;
```

---

## 5. Chức năng quản lý Chuyến bay

**Form nhập:** Số hiệu chuyến bay, Ngày giờ khởi hành, Ngày giờ đến, Điểm khởi hành, Điểm đến, Trạng thái.

**Validation ngày giờ đến:** `ngayGioDen.after(ngayGioKhoiHanh)`
- ✅ Hợp lệ: Khởi hành `01/07/2026 08:00` → Đến `01/07/2026 10:30`
- ❌ Không hợp lệ: Khởi hành `01/07/2026 08:00` → Đến `01/07/2026 07:30`

**Nghiệp vụ đặc biệt:** Nếu trạng thái chuyển thành `Hoãn` hoặc `Hủy`, hệ thống phải cập nhật toàn bộ vé liên quan (`giaVe = 0`) và cập nhật thông báo (`"Chuyến bay đã bị " + trangThaiMoi`).

```java
@Transactional
public void updateFlightStatus(Integer maChuyenBay, String trangThaiMoi) {
    ChuyenBay flight = chuyenBayDAO.findById(maChuyenBay);
    flight.setTrangThai(trangThaiMoi);

    if (trangThaiMoi.equals("Hoãn") || trangThaiMoi.equals("Hủy")) {
        List<VeMayBay> tickets = veDAO.findByFlight(maChuyenBay);
        for (VeMayBay ticket : tickets) {
            ticket.setGiaVe(0L);
            ticket.setThongBao("Chuyến bay đã bị " + trangThaiMoi);
        }
    }
}
```

---

## 6. Chức năng quản lý Hành khách

**Form nhập:** Họ tên, Số điện thoại, Email.

**Validation số điện thoại:** `^0\d{9}$`
- ✅ `0912345678`, `0987654321`
- ❌ `912345678`, `01234567`, `1234567890`

**Validation Email:**
```java
@Email
@NotBlank
private String email;
```

---

## 7. Chức năng quản lý Vé máy bay

**Form nhập:** Hành khách, Chuyến bay, Loại vé, Giá vé, Thông báo.

**ComboBox** — Hành khách load từ `HANH_KHACH`, Chuyến bay load từ `CHUYEN_BAY`:

```jsp
<form:select path="maHanhKhach">
    <form:options
        items="${hanhKhachList}"
        itemValue="maHanhKhach"
        itemLabel="hoTen"/>
</form:select>
```

**Loại vé (danh sách cố định):** `Hạng phổ thông`, `Hạng thương gia`

**Validation giá vé:** `giaVe >= 0 && giaVe % 1000 == 0`
- ✅ `90000`, `1200000`, `3500000`
- ❌ `90500`, `99999`

---

## 8. Tìm kiếm Hành khách

Tìm theo: Mã hành khách, Họ tên, Số điện thoại, Email.

Kết quả: Mã, Họ tên, SĐT, Email.

## 9. Tìm kiếm Vé máy bay

Tìm theo: Mã vé, Số hiệu chuyến bay, Loại vé.

Kết quả: Mã vé, Số hiệu chuyến bay, Loại vé, Giá vé, Thông báo.

---

## 10. Truy vấn JOIN

**SQL:**
```sql
SELECT v.maVe, cb.soHieuChuyenBay, v.loaiVe, v.giaVe, v.thongBao
FROM VE_MAY_BAY v
INNER JOIN CHUYEN_BAY cb ON v.maChuyenBay = cb.maChuyenBay
WHERE cb.soHieuChuyenBay LIKE '%?%'
   OR v.loaiVe LIKE '%?%';
```

**HQL:**
```
SELECT v
FROM VeMayBay v
JOIN v.chuyenBay cb
WHERE cb.soHieuChuyenBay LIKE :keyword
   OR v.loaiVe LIKE :keyword
```

---

## 11. Cấu trúc Project

```
src/main/java
│
├── controller
│   ├── ChuyenBayController
│   ├── HanhKhachController
│   ├── VeMayBayController
│   └── SearchController
│
├── model
│   ├── ChuyenBay
│   ├── HanhKhach
│   ├── VeMayBay
│   └── LichSuChuyenBay
│
├── dao
│   ├── ChuyenBayDAO
│   ├── HanhKhachDAO
│   ├── VeMayBayDAO
│   └── LichSuDAO
│
├── service
│   ├── ChuyenBayService
│   ├── HanhKhachService
│   └── VeMayBayService
│
├── validator
│   ├── ChuyenBayValidator
│   ├── HanhKhachValidator
│   └── VeMayBayValidator
│
└── config
    ├── HibernateConfig
    ├── WebConfig
    └── AppInitializer
```

---

## 12. Giao diện

Yêu cầu: Bootstrap 5, Font Awesome, Responsive Design.

**Dashboard:** Tổng chuyến bay, Tổng hành khách, Tổng vé bán.

**Quản lý chuyến bay:** Thêm chuyến bay, Danh sách chuyến bay.

**Quản lý vé:** Thêm vé, Danh sách vé.

**Tìm kiếm:** Hành khách, Vé máy bay.

---

## 13. Yêu cầu kỹ thuật

- **Framework:** Spring MVC thuần
- **ORM:** Hibernate ORM
- **Database:** MySQL
- **Server:** Apache Tomcat 10
- **Convention:** package `controller`/`service`/`dao`/`model`/`validator`, PascalCase cho Class, camelCase cho biến, `Controller → Service → DAO → Entity`

---

## Bắt đầu (Getting Started)

### Yêu cầu

- JDK 17+
- MySQL 8.x
- Apache Tomcat 10
- IDE: IntelliJ IDEA / Eclipse

### Cài đặt

```bash
git clone https://github.com/nhunguy-swe/airport-management-spring-mvc.git
cd airport-management-spring-mvc
```

### Cấu hình Database

1. Chạy script SQL trong thư mục `database/` để tạo các bảng `CHUYEN_BAY`, `HANH_KHACH`, `VE_MAY_BAY`, `LICH_SU_CHUYEN_BAY` theo thiết kế ở trên.
2. Cập nhật thông tin kết nối trong `HibernateConfig.java`.

> ⚠️ Không hard-code mật khẩu database trực tiếp trong code nếu push lên GitHub public — dùng biến môi trường hoặc file cấu hình đã thêm vào `.gitignore`.

### Chạy ứng dụng

```bash
mvn clean install
```

Deploy file `.war` lên **Apache Tomcat 10**, truy cập tại `http://localhost:8080/quan-ly-san-bay/`.

---

## 14. Kết luận

Hệ thống đáp ứng đầy đủ yêu cầu đề bài: Quản lý Chuyến bay · Quản lý Hành khách · Quản lý Vé máy bay · Quản lý Lịch sử chuyến bay · Validation dữ liệu đầy đủ · ComboBox load dữ liệu từ DB · Cập nhật tự động vé khi chuyến bay bị Hoãn/Hủy · Tìm kiếm Hành khách/Vé máy bay · JOIN dữ liệu bằng Hibernate · Spring MVC thuần · Hibernate ORM · MySQL · Tomcat 10 · Bootstrap + Font Awesome · Tuân thủ Java Coding Convention

### Các điểm trọng tâm khi làm bài thi

**Mapping:**
```
ChuyenBay 1 ---- n VeMayBay
HanhKhach 1 ---- n VeMayBay
ChuyenBay 1 ---- n LichSuChuyenBay
```

**Validation quan trọng:**
```
ngayGioDen > ngayGioKhoiHanh
giaVe % 1000 == 0
^0\d{9}$
```

**Nghiệp vụ bắt buộc:**
```
Nếu Hoãn hoặc Hủy
→ Giá vé = 0
→ Cập nhật thông báo vé
```

**JOIN thường gặp:**
```
VE_MAY_BAY JOIN CHUYEN_BAY JOIN HANH_KHACH
```

---

## Tác giả

- GitHub: [@nhunguy-swe](https://github.com/nhunguy-swe)

---

## Giấy phép

Dự án này được thực hiện cho mục đích học tập/ôn thi cá nhân.
