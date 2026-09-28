package com.example.quanlysanbay.model;

import jakarta.persistence.*;

@Entity
@Table(name = "ve_may_bay")
public class VeMayBay {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ma_ve")
    private int maVe;

    @ManyToOne(fetch = FetchType.EAGER) // Đảm bảo luôn nạp kèm dữ liệu hành khách
    @JoinColumn(name = "ma_hanh_khach")
    private HanhKhach hanhKhach;

    @ManyToOne(fetch = FetchType.EAGER) // Đảm bảo luôn nạp kèm dữ liệu chuyến bay
    @JoinColumn(name = "ma_chuyen_bay")
    private ChuyenBay chuyenBay;

    @Column(name = "loai_ve")
    private String loaiVe;

    @Column(name = "gia_ve")
    private int giaVe;

    @Column(name = "thong_bao")
    private String thongBao;

    // Getters and Setters
    public int getMaVe() { return maVe; }
    public void setMaVe(int maVe) { this.maVe = maVe; }
    public HanhKhach getHanhKhach() { return hanhKhach; }
    public void setHanhKhach(HanhKhach hanhKhach) { this.hanhKhach = hanhKhach; }
    public ChuyenBay getChuyenBay() { return chuyenBay; }
    public void setChuyenBay(ChuyenBay chuyenBay) { this.chuyenBay = chuyenBay; }
    public String getLoaiVe() { return loaiVe; }
    public void setLoaiVe(String loaiVe) { this.loaiVe = loaiVe; }
    public int getGiaVe() { return giaVe; }
    public void setGiaVe(int giaVe) { this.giaVe = giaVe; }
    public String getThongBao() { return thongBao; }
    public void setThongBao(String thongBao) { this.thongBao = thongBao; }
}