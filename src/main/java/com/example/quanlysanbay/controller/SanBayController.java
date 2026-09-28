package com.example.quanlysanbay.controller;

import com.example.quanlysanbay.model.*;
import com.example.quanlysanbay.service.SanBayService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class SanBayController {

    @Autowired
    private SanBayService sanBayService;

    @GetMapping("/")
    public String index() { return "index"; }

    // 1. FORM CHUYẾN BAY
    @GetMapping("/chuyen-bay/add")
    public String viewChuyenBayForm(Model model) {
        // Tạo một đối tượng ChuyenBay rỗng gửi sang JSP để liên kết dữ liệu với thẻ <form:form> hoặc th:object
        model.addAttribute("chuyenBay", new ChuyenBay());
        // Lấy toàn bộ danh sách chuyến bay hiện có từ CSDL nạp vào biến "dsChuyenBay" hiển thị ngay phía dưới form
        model.addAttribute("dsChuyenBay", sanBayService.getAllChuyenBay());
        return "form-chuyen-bay";
    }

    @PostMapping("/chuyen-bay/save")
    public String saveChuyenBay(@ModelAttribute("chuyenBay") ChuyenBay cb, Model model) {
        // KIỂM TRA ĐIỀU KIỆN (Validation): Thời gian hạ cánh phải diễn ra SAU thời gian cất cánh
        if (cb.getNgayGioDen() != null && cb.getNgayGioKhoiHanh() != null
                && !cb.getNgayGioDen().isAfter(cb.getNgayGioKhoiHanh())) {
            // Nếu sai, lưu thông báo lỗi vào Model để hiển thị thông báo alert trên màn hình JSP
            model.addAttribute("error", "Ngày giờ đến phải sau ngày giờ khởi hành!");
            // Nạp lại danh sách chuyến bay để bảng hiển thị bên dưới không bị trống
            model.addAttribute("dsChuyenBay", sanBayService.getAllChuyenBay());
            return "form-chuyen-bay";
        }
        // Nếu thỏa mãn điều kiện, chuyển tiếp xuống tầng Service xử lý lưu vào CSDL
        sanBayService.saveChuyenBay(cb);
        // Dùng cơ chế redirect để tránh lỗi "F5 trùng lặp dữ liệu" (Duplicate submission)
        return "redirect:/chuyen-bay/add";
    }

    // Edit Trạng thái chuyến bay
    @GetMapping("/chuyen-bay/edit/{id}")
    public String editChuyenBay(@PathVariable("id") int id, Model model) {
        // Lấy thông tin chuyến bay cụ thể cần chỉnh sửa bằng ID đưa lên form chỉnh sửa
        model.addAttribute("chuyenBay", sanBayService.getChuyenBayById(id));
        // Đảm bảo bảng danh sách bên dưới vẫn load đầy đủ các chuyến bay khác
        model.addAttribute("dsChuyenBay", sanBayService.getAllChuyenBay());
        return "form-chuyen-bay";
    }

    // 2. FORM HÀNH KHÁCH
    @GetMapping("/hanh-khach/add")
    public String viewHanhKhachForm(Model model) {
        model.addAttribute("hanhKhach", new HanhKhach());
        return "form-hanh-khach";
    }

    @PostMapping("/hanh-khach/save")
    public String saveHanhKhach(@ModelAttribute("hanhKhach") HanhKhach hk, Model model) {
        // KIỂM TRA ĐIỀU KIỆN (Validation): Số điện thoại phải chuẩn định dạng Việt Nam (10 chữ số, số 0 đầu)
        if (hk.getSoDienThoai() == null || !hk.getSoDienThoai().matches("^0\\d{9}$")) {
            model.addAttribute("error", "Số điện thoại phải gồm 10 chữ số và bắt đầu bằng số 0!");
            return "form-hanh-khach"; // Giữ lại trang nếu nhập sai số điện thoại
        }
        // Lưu hành khách
        sanBayService.saveHanhKhach(hk);
        return "redirect:/hanh-khach/add?success=true";
    }

    // 3. FORM VÉ MÁY BAY
    @GetMapping("/ve/add")
    public String viewVeForm(Model model) {
        model.addAttribute("ve", new VeMayBay());
        // LẤY DỮ LIỆU ĐỘNG: Đổ toàn bộ danh sách Hành Khách từ DB ra làm dữ liệu chọn (Dropdown/Select)
        model.addAttribute("dsHanhKhach", sanBayService.getAllHanhKhach()); // Load từ CSDL
        // LẤY DỮ LIỆU ĐỘNG: Đổ toàn bộ danh sách Chuyến Bay từ DB ra làm dữ liệu chọn
        model.addAttribute("dsChuyenBay", sanBayService.getAllChuyenBay()); // Load từ CSDL
        return "form-ve";
    }

    @PostMapping("/ve/save")
    public String saveVe(@ModelAttribute("ve") VeMayBay ve,
                         @RequestParam("maHanhKhach") int maHanhKhach,
                         @RequestParam("maChuyenBay") int maChuyenBay, Model model) {

        // KIỂM TRA ĐIỀU KIỆN (Validation): Giá vé không được âm và bắt buộc phải là bội số của 1000 VNĐ
        if (ve.getGiaVe() < 0 || ve.getGiaVe() % 1000 != 0) {
            model.addAttribute("error", "Giá vé phải là số nguyên không âm và chia hết cho 1000!");
            // Nạp lại dữ liệu cho các hộp chọn Dropdown để giao diện không bị lỗi mất dữ liệu combobox
            model.addAttribute("dsHanhKhach", sanBayService.getAllHanhKhach());
            model.addAttribute("dsChuyenBay", sanBayService.getAllChuyenBay());
            return "form-ve";
        }

        // Tạo liên kết Object (Mapping quan hệ tương ứng trong Hibernate)
        ve.setHanhKhach(sanBayService.getHanhKhachById(maHanhKhach));
        ve.setChuyenBay(sanBayService.getChuyenBayById(maChuyenBay));
        sanBayService.saveVeMayBay(ve);
        return "redirect:/ve/add?success=true";
    }

    // 1. TRANG TÌM KIẾM HÀNH KHÁCH (Mặc định load toàn bộ khi vào trang)
    @GetMapping("/tim-kiem/khach-hang")
    public String searchKhachHang(@RequestParam(value = "keyword", required = false) String keyword, Model model) {
        // Nếu vừa mở trang, keyword sẽ là null -> gán thành chuỗi rỗng để lấy hết sạch danh sách
        // GIẢI THÍCH: Khi vừa mở trang, tham số 'keyword' trên thanh URL chưa tồn tại (null)
        // Ta ép nó bằng chuỗi rỗng "". Khi truyền chuỗi rỗng vào câu lệnh SQL LIKE '%%', DB sẽ trả ra TẤT CẢ bản ghi.
        if (keyword == null) {
            keyword = "";
        }

        // Gọi service lấy danh sách (kể cả danh sách đầy đủ hoặc danh sách đã lọc)
        // GỬI DỮ LIỆU RA JSP: Đưa mảng danh sách lấy từ DB vào thuộc tính có tên là "dsKetQua"
        model.addAttribute("dsKetQua", sanBayService.searchHanhKhach(keyword.trim()));
        model.addAttribute("currentKeyword", keyword); // Đẩy ngược lại để giữ chữ trong ô input
        return "tim-kiem-khach-hang";
    }

    // 2. TRANG TÌM KIẾM VÉ MÁY BAY (Mặc định load toàn bộ khi vào trang)
    @GetMapping("/tim-kiem/ve")
    public String searchVe(@RequestParam(value = "soHieu", required = false) String soHieu,
                           @RequestParam(value = "loaiVe", required = false) String loaiVe, Model model) {
        // Xử lý dữ liệu null khi vừa vào trang
        // Tương tự, nếu vừa bấm vào trang thì hai bộ lọc này là null -> ép thành chuỗi rỗng để hiển thị toàn bộ vé
        if (soHieu == null) soHieu = "";
        if (loaiVe == null) loaiVe = "";

        // Luôn nạp dữ liệu đổ ra danh sách kết quả bên dưới form
        // GỬI DỮ LIỆU RA JSP: Đưa mảng danh sách lấy từ DB vào thuộc tính có tên là "dsKetQua"
        model.addAttribute("dsKetQua", sanBayService.searchVe(soHieu.trim(), loaiVe.trim()));
        model.addAttribute("currentSoHieu", soHieu);
        model.addAttribute("currentLoaiVe", loaiVe);
        return "tim-kiem-ve";
    }
}
