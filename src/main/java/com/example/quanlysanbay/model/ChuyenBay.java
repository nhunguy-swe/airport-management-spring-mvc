package com.example.quanlysanbay.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "chuyen_bay")
public class ChuyenBay {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ma_chuyen_bay")
    private int maChuyenBay;

    @Column(name = "so_hieu_chuyen_bay")
    private String soHieuChuyenBay;

    @Column(name = "ngay_gio_khoi_hanh")
    private LocalDateTime ngayGioKhoiHanh;

    @Column(name = "ngay_gio_den")
    private LocalDateTime ngayGioDen;

    @Column(name = "diem_khoi_hanh")
    private String diemKhoiHanh;

    @Column(name = "diem_den")
    private String diemDen;

    @Column(name = "trang_thai")
    private String trangThai;

    // Getters and Setters
    public int getMaChuyenBay() { return maChuyenBay; }
    public void setMaChuyenBay(int maChuyenBay) { this.maChuyenBay = maChuyenBay; }
    public String getSoHieuChuyenBay() { return soHieuChuyenBay; }
    public void setSoHieuChuyenBay(String soHieuChuyenBay) { this.soHieuChuyenBay = soHieuChuyenBay; }
    public LocalDateTime getNgayGioKhoiHanh() { return ngayGioKhoiHanh; }
    public void setNgayGioKhoiHanh(LocalDateTime ngayGioKhoiHanh) { this.ngayGioKhoiHanh = ngayGioKhoiHanh; }
    public LocalDateTime getNgayGioDen() { return ngayGioDen; }
    public void setNgayGioDen(LocalDateTime ngayGioDen) { this.ngayGioDen = ngayGioDen; }
    public String getDiemKhoiHanh() { return diemKhoiHanh; }
    public void setDiemKhoiHanh(String diemKhoiHanh) { this.diemKhoiHanh = diemKhoiHanh; }
    public String getDiemDen() { return diemDen; }
    public void setDiemDen(String diemDen) { this.diemDen = diemDen; }
    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }
}