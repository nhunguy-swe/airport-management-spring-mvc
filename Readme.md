# HỆ THỐNG QUẢN LÝ SÂN BAY (AIRPORT MANAGEMENT SYSTEM)

## 1. Giới thiệu

Hệ thống quản lý sân bay được xây dựng nhằm quản lý:

* Chuyến bay
* Hành khách
* Vé máy bay
* Lịch sử thay đổi trạng thái chuyến bay

Mỗi hành khách có thể đặt nhiều vé máy bay cho các chuyến bay khác nhau.

Mỗi chuyến bay có thể có nhiều hành khách đặt vé.

Hệ thống được phát triển bằng:

* Spring MVC (Không sử dụng Spring Boot)
* Hibernate ORM
* MySQL
* JSP/JSTL
* Apache Tomcat 10
* Bootstrap 5
* Font Awesome

---

# 2. Công nghệ sử dụng

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

# 3. Thiết kế cơ sở dữ liệu

## Bảng CHUYEN_BAY

| Cột             | Kiểu dữ liệu | Ràng buộc          |
| --------------- | ------------ | ------------------ |
| maChuyenBay     | INT          | PK, AUTO_INCREMENT |
| soHieuChuyenBay | VARCHAR(20)  | NOT NULL           |
| ngayGioKhoiHanh | DATETIME     | NOT NULL           |
| ngayGioDen      | DATETIME     | NOT NULL           |
| diemKhoiHanh    | VARCHAR(100) | NOT NULL           |
| diemDen         | VARCHAR(100) | NOT NULL           |
| trangThai       | VARCHAR(50)  | NOT NULL           |

### Giá trị trạng thái

```text
Đúng giờ
Hoãn
Hủy
Đổi lịch
```

---

## Bảng HANH_KHACH

| Cột         | Kiểu dữ liệu | Ràng buộc          |
| ----------- | ------------ | ------------------ |
| maHanhKhach | INT          | PK, AUTO_INCREMENT |
| hoTen       | VARCHAR(100) | NOT NULL           |
| soDienThoai | VARCHAR(10)  | NOT NULL           |
| email       | VARCHAR(100) | NOT NULL           |

---

## Bảng VE_MAY_BAY

| Cột         | Kiểu dữ liệu | Ràng buộc          |
| ----------- | ------------ | ------------------ |
| maVe        | INT          | PK, AUTO_INCREMENT |
| maHanhKhach | INT          | FK                 |
| maChuyenBay | INT          | FK                 |
| loaiVe      | VARCHAR(50)  | NOT NULL           |
| giaVe       | BIGINT       | NOT NULL           |
| thongBao    | VARCHAR(255) |                    |

### Khóa ngoại

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

---

## Bảng LICH_SU_CHUYEN_BAY

| Cột             | Kiểu dữ liệu | Ràng buộc          |
| --------------- | ------------ | ------------------ |
| maLichSu        | INT          | PK, AUTO_INCREMENT |
| maChuyenBay     | INT          | FK                 |
| trangThaiCu     | VARCHAR(50)  |                    |
| trangThaiMoi    | VARCHAR(50)  |                    |
| thoiGianCapNhat | DATETIME     |                    |

---

# 4. Quan hệ dữ liệu Hibernate

## ChuyenBay Entity

```java
@OneToMany(mappedBy = "chuyenBay")
private List<VeMayBay> danhSachVe;

@OneToMany(mappedBy = "chuyenBay")
private List<LichSuChuyenBay> lichSuList;
```

---

## HanhKhach Entity

```java
@OneToMany(mappedBy = "hanhKhach")
private List<VeMayBay> danhSachVe;
```

---

## VeMayBay Entity

```java
@ManyToOne
@JoinColumn(name = "maHanhKhach")
private HanhKhach hanhKhach;

@ManyToOne
@JoinColumn(name = "maChuyenBay")
private ChuyenBay chuyenBay;
```

---

# 5. Chức năng quản lý Chuyến bay

## Form nhập Chuyến bay

Thông tin nhập:

* Số hiệu chuyến bay
* Ngày giờ khởi hành
* Ngày giờ đến
* Điểm khởi hành
* Điểm đến
* Trạng thái

---

## Validation

### Ngày giờ đến

Điều kiện:

```java
ngayGioDen.after(ngayGioKhoiHanh)
```

Ví dụ:

✅ Hợp lệ

```text
Khởi hành: 01/07/2026 08:00
Đến:       01/07/2026 10:30
```

❌ Không hợp lệ

```text
Khởi hành: 01/07/2026 08:00
Đến:       01/07/2026 07:30
```

---

## Nghiệp vụ đặc biệt

Nếu trạng thái chuyến bay chuyển thành:

```text
Hoãn
Hủy
```

Thì hệ thống phải:

### Cập nhật toàn bộ vé liên quan

```java
ticket.setGiaVe(0);
```

### Cập nhật thông báo

```java
ticket.setThongBao(
    "Chuyến bay đã bị " + trangThaiMoi
);
```

Ví dụ Service:

```java
@Transactional
public void updateFlightStatus(
        Integer maChuyenBay,
        String trangThaiMoi) {

    ChuyenBay flight =
            chuyenBayDAO.findById(maChuyenBay);

    flight.setTrangThai(trangThaiMoi);

    if(trangThaiMoi.equals("Hoãn")
            || trangThaiMoi.equals("Hủy")) {

        List<VeMayBay> tickets =
                veDAO.findByFlight(maChuyenBay);

        for(VeMayBay ticket : tickets){
            ticket.setGiaVe(0L);
            ticket.setThongBao(
                "Chuyến bay đã bị " + trangThaiMoi
            );
        }
    }
}
```

---

# 6. Chức năng quản lý Hành khách

## Form nhập Hành khách

Thông tin:

* Họ tên
* Số điện thoại
* Email

---

## Validation số điện thoại

Điều kiện:

```java
^0\d{9}$
```

Ví dụ:

✅ Hợp lệ

```text
0912345678
0987654321
```

❌ Không hợp lệ

```text
912345678
01234567
1234567890
```

---

## Validation Email

```java
@Email
@NotBlank
private String email;
```

---

# 7. Chức năng quản lý Vé máy bay

## Form nhập Vé

Thông tin:

* Hành khách
* Chuyến bay
* Loại vé
* Giá vé
* Thông báo

---

## ComboBox

### Hành khách

Load từ bảng:

```text
HANH_KHACH
```

### Chuyến bay

Load từ bảng:

```text
CHUYEN_BAY
```

Ví dụ:

```jsp
<form:select path="maHanhKhach">
    <form:options
        items="${hanhKhachList}"
        itemValue="maHanhKhach"
        itemLabel="hoTen"/>
</form:select>
```

---

## Loại vé

Danh sách cố định:

```text
Hạng phổ thông
Hạng thương gia
```

---

## Validation Giá vé

Điều kiện:

```java
giaVe >= 0
&& giaVe % 1000 == 0
```

Ví dụ:

✅ Hợp lệ

```text
90000
1200000
3500000
```

❌ Không hợp lệ

```text
90500
99999
```

---

# 8. Tìm kiếm Hành khách

## Form tìm kiếm

Tìm theo:

* Mã hành khách
* Họ tên
* Số điện thoại
* Email

---

## Kết quả

| Mã | Họ tên | SĐT | Email |
| -- | ------ | --- | ----- |

---

# 9. Tìm kiếm Vé máy bay

## Form tìm kiếm

Tìm theo:

* Mã vé
* Số hiệu chuyến bay
* Loại vé

---

## Kết quả

| Mã vé | Số hiệu chuyến bay | Loại vé | Giá vé | Thông báo |
| ----- | ------------------ | ------- | ------ | --------- |

---

# 10. Truy vấn JOIN

## SQL

```sql
SELECT v.maVe,
       cb.soHieuChuyenBay,
       v.loaiVe,
       v.giaVe,
       v.thongBao
FROM VE_MAY_BAY v
INNER JOIN CHUYEN_BAY cb
ON v.maChuyenBay = cb.maChuyenBay
WHERE cb.soHieuChuyenBay LIKE '%?%'
   OR v.loaiVe LIKE '%?%';
```

---

## HQL

```java
SELECT v
FROM VeMayBay v
JOIN v.chuyenBay cb
WHERE cb.soHieuChuyenBay LIKE :keyword
   OR v.loaiVe LIKE :keyword
```

---

# 11. Cấu trúc Project

```text
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

# 12. Giao diện

Yêu cầu:

* Bootstrap 5
* Font Awesome
* Responsive Design

Trang chính:

### Dashboard

* Tổng chuyến bay
* Tổng hành khách
* Tổng vé bán

### Quản lý chuyến bay

* Thêm chuyến bay
* Danh sách chuyến bay

### Quản lý vé

* Thêm vé
* Danh sách vé

### Tìm kiếm

* Hành khách
* Vé máy bay

---

# 13. Yêu cầu kỹ thuật

## Framework

* Spring MVC thuần

## ORM

* Hibernate ORM

## Database

* MySQL

## Server

* Apache Tomcat 10

## Convention

* controller
* service
* dao
* model
* validator

Tuân thủ:

* PascalCase cho Class
* camelCase cho biến
* Controller → Service → DAO → Entity

---

# 14. Kết luận

Hệ thống đáp ứng đầy đủ yêu cầu đề bài:

* Quản lý Chuyến bay
* Quản lý Hành khách
* Quản lý Vé máy bay
* Quản lý Lịch sử chuyến bay
* Validation dữ liệu đầy đủ
* ComboBox load dữ liệu từ DB
* Cập nhật tự động vé khi chuyến bay bị Hoãn/Hủy
* Tìm kiếm thông tin Hành khách
* Tìm kiếm Vé máy bay
* JOIN dữ liệu bằng Hibernate
* Spring MVC thuần
* Hibernate ORM
* MySQL
* Tomcat 10
* Bootstrap + Font Awesome
* Tuân thủ Java Coding Convention

## Các điểm trọng tâm khi làm bài thi

### Mapping

```java
ChuyenBay 1 ---- n VeMayBay
HanhKhach 1 ---- n VeMayBay
ChuyenBay 1 ---- n LichSuChuyenBay
```

### Validation quan trọng

```java
ngayGioDen > ngayGioKhoiHanh
```

```java
giaVe % 1000 == 0
```

```java
^0\\d{9}$
```

### Nghiệp vụ bắt buộc

```java
Nếu Hoãn hoặc Hủy
→ Giá vé = 0
→ Cập nhật thông báo vé
```

### JOIN thường gặp

```sql
VE_MAY_BAY
JOIN CHUYEN_BAY
JOIN HANH_KHACH
```
