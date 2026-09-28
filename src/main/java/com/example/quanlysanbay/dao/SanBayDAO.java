package com.example.quanlysanbay.dao;

import com.example.quanlysanbay.model.*;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public class SanBayDAO {

    // @Autowired: Tự động inject (nhúng) đối tượng SessionFactory từ AppConfig vào đây
    @Autowired
    private SessionFactory sessionFactory;

    /**
     * Hàm tiện ích nội bộ nhằm lấy Session hiện tại của Hibernate đang gắn liền với Transaction.
     * Giúp thực thi các câu lệnh SQL/HQL mà không cần mở/đóng session thủ công.
     */
    private Session currentSession() {
        return sessionFactory.getCurrentSession();
    }

    // Chuyen Bay
    // Thêm mới một chuyến bay vào CSDL bằng phương thức persist() của JPA
    public void saveChuyenBay(ChuyenBay cb) { currentSession().persist(cb); }
    // Cập nhật thông tin chuyến bay đã tồn tại bằng phương thức merge()
    public void updateChuyenBay(ChuyenBay cb) { currentSession().merge(cb); }
    // Tìm kiếm và lấy ra thực thể ChuyenBay dựa vào Khóa chính (ID)
    public ChuyenBay getChuyenBayById(int id) { return currentSession().get(ChuyenBay.class, id); }
    // Lấy toàn bộ danh sách chuyến bay bằng ngôn ngữ truy vấn HQL (Hibernate Query Language)
    public List<ChuyenBay> getAllChuyenBay() {
        return currentSession().createQuery("from ChuyenBay", ChuyenBay.class).list();
    }

    // Hanh Khach
    // Lưu thông tin khách hàng mới vào database
    public void saveHanhKhach(HanhKhach hk) { currentSession().persist(hk); }
    // Tìm hành khách theo ID (Khóa chính)
    public HanhKhach getHanhKhachById(int id) { return currentSession().get(HanhKhach.class, id); }
    // Tải toàn bộ danh sách tất cả hành khách hiện có trong database
    public List<HanhKhach> getAllHanhKhach() {
        return currentSession().createQuery("from HanhKhach", HanhKhach.class).list();
    }

    // Ve May Bay
    // Lưu thông tin vé mới mua/bán vào hệ thống database
    public void saveVeMayBay(VeMayBay ve) { currentSession().persist(ve); }
    /**
     * Tìm danh sách các vé thuộc về một chuyến bay cụ thể bằng ID chuyến bay.
     * Thường dùng để duyệt tìm danh sách vé cần đổi giá về 0 hoặc thông báo khi chuyến bay bị Hoãn/Hủy.
     */
    public List<VeMayBay> getVesByChuyenBay(int maChuyenBay) {
        String hql = "from VeMayBay where chuyenBay.maChuyenBay = :id";
        return currentSession().createQuery(hql, VeMayBay.class)
                .setParameter("id", maChuyenBay).list();
    }
    // Cập nhật thông tin vé (ví dụ: cập nhật lại giá vé hoặc cập nhật thông báo)
    public void updateVeMayBay(VeMayBay ve) { currentSession().merge(ve); }


    /**
     * CHỨC NĂNG: Tra cứu hành khách bằng 1 câu lệnh HQL duy nhất (Không dùng if-else).
     * CƠ CHẾ DỄ HIỂU: Nếu từ khóa trống (:kw = ''), mệnh đề OR đầu tiên đúng nên toàn bộ bộ lọc
     * bị bỏ qua -> Tự động trả về toàn bộ danh sách khách hàng khi vừa vào trang.
     */
    public List<HanhKhach> searchHanhKhach(String keyword) {
        // 1. Chuẩn hóa dữ liệu đầu vào: Nếu null hoặc rỗng thì đưa về chuỗi rỗng ""
        String kw = (keyword == null) ? "" : keyword.trim();

        // 2. Viết câu lệnh HQL gom tất cả điều kiện (Dùng toán tử OR thông minh)
        String hql = "from HanhKhach where :kw = '' " +
                "or hoTen like :kw " +
                "or soDienThoai like :kw " +
                "or email like :kw";

        // 3. Tạo câu lệnh truy vấn và truyền tham số trực tiếp
        return currentSession().createQuery(hql, HanhKhach.class)
                .setParameter("kw", kw.isEmpty() ? "" : "%" + kw + "%")
                .list();
    }

    /**
     * CHỨC NĂNG: Tra cứu vé máy bay bằng 1 câu lệnh HQL duy nhất.
     * CƠ CHẾ DỄ HIỂU: Nếu tham số truyền vào trống (bằng ''), điều kiện OR sẽ tự kích hoạt
     * giúp bỏ qua bộ lọc đó, nhờ vậy load được toàn bộ dữ liệu khi vừa tải trang.
     */
    public List<VeMayBay> searchVe(String soHieu, String loaiVe) {
        // 1. Chuẩn hóa dữ liệu đầu vào: Nếu null thì biến thành chuỗi rỗng để dễ so sánh trong HQL
        String sh = (soHieu == null) ? "" : soHieu.trim();
        String lv = (loaiVe == null) ? "" : loaiVe.trim();

        // 2. Viết câu lệnh HQL duy nhất (Vẫn giữ 'join fetch' để tránh lỗi LazyInitialization ở JSP)
        String hql = "select v from VeMayBay v " +
                "left join fetch v.chuyenBay " +
                "left join fetch v.hanhKhach " +
                "where (:soHieu = '' or v.chuyenBay.soHieuChuyenBay like :soHieu) " +
                "and (:loaiVe = '' or v.loaiVe = :loaiVe)";

        // 3. Tạo câu lệnh truy vấn và truyền tham số thẳng thừng, không cần check `if` phức tạp nữa
        return currentSession().createQuery(hql, VeMayBay.class)
                .setParameter("soHieu", sh.isEmpty() ? "" : "%" + sh + "%")
                .setParameter("loaiVe", lv)
                .list();
    }
}
