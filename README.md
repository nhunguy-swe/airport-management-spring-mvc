# AIRPORT MANAGEMENT SYSTEM

<p>
  <img src="https://img.shields.io/badge/Java-17%2B-orange" alt="Java">
  <img src="https://img.shields.io/badge/Spring%20MVC-6.x-brightgreen" alt="Spring MVC">
  <img src="https://img.shields.io/badge/Hibernate-6.x-blue" alt="Hibernate">
  <img src="https://img.shields.io/badge/MySQL-8.x-4479A1" alt="MySQL">
  <img src="https://img.shields.io/badge/Tomcat-10.x-yellow" alt="Tomcat 10">
</p>

## 1. Introduction

The Airport Management System is built to manage:

- Flights
- Passengers
- Tickets
- Flight status change history

A passenger can book multiple tickets for different flights. A flight can have multiple passengers with booked tickets.

Built with: Spring MVC (no Spring Boot), Hibernate ORM, MySQL, JSP/JSTL, Apache Tomcat 10, Bootstrap 5, Font Awesome.

---

## 2. Tech Stack

| Technology   | Version |
| ------------ | ------- |
| Java         | 17+     |
| Spring MVC   | 6.x     |
| Hibernate    | 6.x     |
| MySQL        | 8.x     |
| JSP/JSTL     | Latest  |
| Maven        | Latest  |
| Tomcat       | 10.x    |
| Bootstrap    | 5.x     |
| Font Awesome | 6.x     |

---

## 3. Database Design

### FLIGHT Table (CHUYEN_BAY)

| Column          | Data Type    | Constraint          |
| --------------- | ------------ | -------------------- |
| maChuyenBay     | INT          | PK, AUTO_INCREMENT   |
| soHieuChuyenBay | VARCHAR(20)  | NOT NULL              |
| ngayGioKhoiHanh | DATETIME     | NOT NULL               |
| ngayGioDen      | DATETIME     | NOT NULL                |
| diemKhoiHanh    | VARCHAR(100) | NOT NULL                 |
| diemDen         | VARCHAR(100) | NOT NULL                  |
| trangThai       | VARCHAR(50)  | NOT NULL                   |

**Status values:** `On time`, `Delayed`, `Cancelled`, `Rescheduled`

### PASSENGER Table (HANH_KHACH)

| Column      | Data Type    | Constraint          |
| ----------- | ------------ | -------------------- |
| maHanhKhach | INT          | PK, AUTO_INCREMENT   |
| hoTen       | VARCHAR(100) | NOT NULL              |
| soDienThoai | VARCHAR(10)  | NOT NULL               |
| email       | VARCHAR(100) | NOT NULL                |

### TICKET Table (VE_MAY_BAY)

| Column      | Data Type    | Constraint          |
| ----------- | ------------ | -------------------- |
| maVe        | INT          | PK, AUTO_INCREMENT   |
| maHanhKhach | INT          | FK                    |
| maChuyenBay | INT          | FK                     |
| loaiVe      | VARCHAR(50)  | NOT NULL                |
| giaVe       | BIGINT       | NOT NULL                 |
| thongBao    | VARCHAR(255) |                            |

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

### FLIGHT HISTORY Table (LICH_SU_CHUYEN_BAY)

| Column          | Data Type    | Constraint          |
| --------------- | ------------ | -------------------- |
| maLichSu        | INT          | PK, AUTO_INCREMENT   |
| maChuyenBay     | INT          | FK                    |
| trangThaiCu     | VARCHAR(50)  |                        |
| trangThaiMoi    | VARCHAR(50)  |                         |
| thoiGianCapNhat | DATETIME     |                          |

---

## 4. Hibernate Relationships

**ChuyenBay (Flight) Entity**
```java
@OneToMany(mappedBy = "chuyenBay")
private List<VeMayBay> danhSachVe;

@OneToMany(mappedBy = "chuyenBay")
private List<LichSuChuyenBay> lichSuList;
```

**HanhKhach (Passenger) Entity**
```java
@OneToMany(mappedBy = "hanhKhach")
private List<VeMayBay> danhSachVe;
```

**VeMayBay (Ticket) Entity**
```java
@ManyToOne
@JoinColumn(name = "maHanhKhach")
private HanhKhach hanhKhach;

@ManyToOne
@JoinColumn(name = "maChuyenBay")
private ChuyenBay chuyenBay;
```

---

## 5. Flight Management

**Input form:** Flight number, Departure date/time, Arrival date/time, Departure point, Destination, Status.

**Arrival date/time validation:** `ngayGioDen.after(ngayGioKhoiHanh)`
- ✅ Valid: Departure `01/07/2026 08:00` → Arrival `01/07/2026 10:30`
- ❌ Invalid: Departure `01/07/2026 08:00` → Arrival `01/07/2026 07:30`

**Special business rule:** If the flight status changes to `Delayed` or `Cancelled`, the system must update all related tickets (`giaVe = 0`) and their notification message (`"Flight has been " + trangThaiMoi`).

```java
@Transactional
public void updateFlightStatus(Integer maChuyenBay, String trangThaiMoi) {
    ChuyenBay flight = chuyenBayDAO.findById(maChuyenBay);
    flight.setTrangThai(trangThaiMoi);

    if (trangThaiMoi.equals("Hoãn") || trangThaiMoi.equals("Hủy")) {
        List<VeMayBay> tickets = veDAO.findByFlight(maChuyenBay);
        for (VeMayBay ticket : tickets) {
            ticket.setGiaVe(0L);
            ticket.setThongBao("Flight has been " + trangThaiMoi);
        }
    }
}
```

---

## 6. Passenger Management

**Input form:** Full name, Phone number, Email.

**Phone number validation:** `^0\d{9}$`
- ✅ `0912345678`, `0987654321`
- ❌ `912345678`, `01234567`, `1234567890`

**Email validation:**
```java
@Email
@NotBlank
private String email;
```

---

## 7. Ticket Management

**Input form:** Passenger, Flight, Ticket type, Price, Notification.

**ComboBox** — Passengers loaded from `HANH_KHACH`, Flights loaded from `CHUYEN_BAY`:

```jsp
<form:select path="maHanhKhach">
    <form:options
        items="${hanhKhachList}"
        itemValue="maHanhKhach"
        itemLabel="hoTen"/>
</form:select>
```

**Ticket type (fixed list):** `Economy Class`, `Business Class`

**Price validation:** `giaVe >= 0 && giaVe % 1000 == 0`
- ✅ `90000`, `1200000`, `3500000`
- ❌ `90500`, `99999`

---

## 8. Passenger Search

Search by: Passenger ID, Full name, Phone number, Email.

Results: ID, Full name, Phone, Email.

## 9. Ticket Search

Search by: Ticket ID, Flight number, Ticket type.

Results: Ticket ID, Flight number, Ticket type, Price, Notification.

---

## 10. JOIN Queries

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

## 11. Project Structure

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

## 12. UI

Requirements: Bootstrap 5, Font Awesome, Responsive Design.

**Dashboard:** Total flights, Total passengers, Total tickets sold.

**Flight Management:** Add a flight, list of flights.

**Ticket Management:** Add a ticket, list of tickets.

**Search:** Passengers, Tickets.

---

## 13. Technical Requirements

- **Framework:** Plain Spring MVC (no Spring Boot)
- **ORM:** Hibernate ORM
- **Database:** MySQL
- **Server:** Apache Tomcat 10
- **Convention:** packages `controller`/`service`/`dao`/`model`/`validator`, PascalCase for classes, camelCase for variables, `Controller → Service → DAO → Entity`

---

## Getting Started

### Requirements

- JDK 17+
- MySQL 8.x
- Apache Tomcat 10
- IDE: IntelliJ IDEA / Eclipse

### Installation

```bash
git clone https://github.com/nhunguy-swe/airport-management-spring-mvc.git
cd airport-management-spring-mvc
```

### Database Setup

1. Run the SQL script in the `database/` folder to create the `CHUYEN_BAY`, `HANH_KHACH`, `VE_MAY_BAY`, and `LICH_SU_CHUYEN_BAY` tables per the design above.
2. Update the connection info in `HibernateConfig.java`.

> ⚠️ Don't hard-code the database password directly in your code if pushing to a public GitHub repo — use environment variables or a config file added to `.gitignore` instead.

### Running the Application

```bash
mvn clean install
```

Deploy the resulting `.war` file to **Apache Tomcat 10** and access it at `http://localhost:8080/quan-ly-san-bay/`.

---

## 14. Conclusion

The system fully meets the requirements: Flight management · Passenger management · Ticket management · Flight history management · Full data validation · ComboBox loaded from the database · Automatic ticket updates when a flight is Delayed/Cancelled · Passenger/Ticket search · Data joins with Hibernate · Plain Spring MVC · Hibernate ORM · MySQL · Tomcat 10 · Bootstrap + Font Awesome · Follows Java coding convention

### Key Points for the Exam

**Mapping:**
```
ChuyenBay 1 ---- n VeMayBay
HanhKhach 1 ---- n VeMayBay
ChuyenBay 1 ---- n LichSuChuyenBay
```

**Important validations:**
```
ngayGioDen > ngayGioKhoiHanh
giaVe % 1000 == 0
^0\d{9}$
```

**Required business rule:**
```
If Delayed or Cancelled
→ Ticket price = 0
→ Update ticket notification
```

**Common JOIN:**
```
VE_MAY_BAY JOIN CHUYEN_BAY JOIN HANH_KHACH
```

---

## Author

- GitHub: [@nhunguy-swe](https://github.com/nhunguy-swe)

---

## License

Created for learning/exam-practice purposes.
