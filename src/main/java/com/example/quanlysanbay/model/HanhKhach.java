package com.example.quanlysanbay.model;

import jakarta.persistence.*;

@Entity
@Table(name = "hanh_khach")
public class HanhKhach {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ma_hanh_khach")
    private int maHanhKhach;

    @Column(name = "ho_ten")
    private String hoTen;

    @Column(name = "so_dien_thoai")
    private String soDienThoai;

    @Column(name = "email")
    private String email;

    // Getters and Setters
    public int getMaHanhKhach() { return maHanhKhach; }
    public void setMaHanhKhach(int maHanhKhach) { this.maHanhKhach = maHanhKhach; }
    public String getHoTen() { return hoTen; }
    public void setHoTen(String hoTen) { this.hoTen = hoTen; }
    public String getSoDienThoai() { return soDienThoai; }
    public void setSoDienThoai(String soDienThoai) { this.soDienThoai = soDienThoai; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}