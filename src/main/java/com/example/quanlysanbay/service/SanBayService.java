package com.example.quanlysanbay.service;

import com.example.quanlysanbay.dao.SanBayDAO;
import com.example.quanlysanbay.model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@Transactional
public class SanBayService {

    @Autowired
    private  SanBayDAO sanBayDAO;

    // Chuyen bay xử lý nghiệp vụ hoãn/hủy
    public void saveChuyenBay(ChuyenBay cb) {

        if (cb.getMaChuyenBay() == 0) { // Kiểm tra nếu mã chuyến bay bằng 0 tức là đây là hành động "THÊM MỚI CHUYẾN BAY"
            sanBayDAO.saveChuyenBay(cb); // Gọi DAO để insert chuyến bay mới vào CSDL

            // Ngược lại, nếu mã chuyến bay đã tồn tại (!= 0) tức là hành động "CẬP NHẬT/CẬP NHẬT TRẠNG THÁI CHUYẾN BAY"
        } else {
            // YÊU CẦU ĐỀ BÀI: Nếu trạng thái chuyến bay được đổi thành "Hoãn" hoặc "Hủy"
            // Nghiệp vụ Hoãn/Hủy tự động cập nhật vé
            if ("Hoãn".equals(cb.getTrangThai()) || "Hủy".equals(cb.getTrangThai())) {
                // 1. Tìm ra tất cả các vé máy bay đã được bán thuộc về chuyến bay này
                List<VeMayBay> dsVe = sanBayDAO.getVesByChuyenBay(cb.getMaChuyenBay());
                // 2. Duyệt vòng lặp qua từng chiếc vé tìm được để cập nhật lại thông tin theo luật nghiệp vụ
                for (VeMayBay ve : dsVe) {
                    ve.setGiaVe(0); // Đặt giá vé về 0 VNĐ
                    ve.setThongBao("Chuyến bay đã bị " + cb.getTrangThai().toLowerCase()); // Cập nhật thông báo trạng thái
                    sanBayDAO.updateVeMayBay(ve); // Ra lệnh cho DAO lưu cập nhật thay đổi của chiếc vé này xuống DB
                }
            }

            // 3. Sau khi xử lý các vé liên quan xong, tiến hành cập nhật thông tin mới của chính chuyến bay đó
            sanBayDAO.updateChuyenBay(cb);
        }
    }

    // Lấy toàn bộ danh sách chuyến bay từ DAO để đổ ra form
    public List<ChuyenBay> getAllChuyenBay() { return sanBayDAO.getAllChuyenBay(); }
    // Tìm kiếm thông tin chi tiết một chuyến bay cụ thể dựa theo mã ID
    public ChuyenBay getChuyenBayById(int id) { return sanBayDAO.getChuyenBayById(id); }

    // Hanh khach
    // Lưu hành khách mới vào hệ thống
    public void saveHanhKhach(HanhKhach hk) { sanBayDAO.saveHanhKhach(hk); }
    // Tải danh sách tất cả hành khách để phục vụ nạp vào dropdown/combobox lúc đặt vé
    public List<HanhKhach> getAllHanhKhach() { return sanBayDAO.getAllHanhKhach(); }

    /**
     * CHỨC NĂNG TÌM KIẾM HÀNH KHÁCH:
     * Nhận từ khóa tìm kiếm (kw) từ Controller, chuyển tiếp xuống DAO xử lý.
     * Vì ở tầng DAO đã được cấu hình tự động bắt chuỗi trống "", nên khi 'kw' truyền vào trống,
     * hàm này sẽ tự động cung cấp TOÀN BỘ danh sách hành khách ra màn hình mà không cần bấm nút tìm kiếm.
     */
    public List<HanhKhach> searchHanhKhach(String kw) { return sanBayDAO.searchHanhKhach(kw); }
    // Lấy thông tin một hành khách theo mã ID phục vụ việc binding dữ liệu
    public HanhKhach getHanhKhachById(int id) { return sanBayDAO.getHanhKhachById(id); }

    // Ve may bay
    // Lưu thông tin vé máy bay mới được tạo xuống database
    public void saveVeMayBay(VeMayBay ve) { sanBayDAO.saveVeMayBay(ve); }

    /**
     * CHỨC NĂNG TRA CỨU VÉ MÁY BAY ĐỘNG:
     * Nhận bộ lọc bao gồm Số hiệu chuyến bay và Loại vé (Hạng vé) từ Controller gửi xuống.
     * Tương tự, nếu hai bộ lọc này truyền vào là chuỗi trống, hàm sẽ tự động cung cấp
     * TOÀN BỘ danh sách vé máy bay hiện có trong CSDL lên màn hình tra cứu.
     */
    public List<VeMayBay> searchVe(String soHieu, String loaiVe) { return sanBayDAO.searchVe(soHieu, loaiVe); }
}
