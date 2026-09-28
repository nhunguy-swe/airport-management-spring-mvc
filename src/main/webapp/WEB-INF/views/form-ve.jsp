<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Đặt Vé Máy Bay</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<jsp:include page="header.jsp" />
<div class="container mt-5" style="max-width: 700px;">
    <a href="${pageContext.request.contextPath}/" class="btn btn-secondary mb-3">Quay lại</a>
    <div class="card shadow p-4">
        <h2 class="text-dark mb-4 text-center">Xuất Vé Máy Bay Mới</h2>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        <c:if test="${param.success}">
            <div class="alert alert-success">Đặt vé thành công!</div>
        </c:if>
        <form action="${pageContext.request.contextPath}/ve/save" method="post">
            <div class="mb-3">
                <label class="form-label">Hành khách</label>
                <select class="form-select" name="maHanhKhach" required>
                    <c:forEach var="hk" items="${dsHanhKhach}">
                        <option value="${hk.maHanhKhach}">${hk.hoTen} - ${hk.soDienThoai}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="mb-3">
                <label class="form-label">Số hiệu chuyến bay</label>
                <select class="form-select" name="maChuyenBay" required>
                    <c:forEach var="cb" items="${dsChuyenBay}">
                        <option value="${cb.maChuyenBay}">${cb.soHieuChuyenBay} (${cb.diemKhoiHanh} -> ${cb.diemDen})</option>
                    </c:forEach>
                </select>
            </div>
            <div class="mb-3">
                <label class="form-label">Hạng vé (Loại vé)</label>
                <select class="form-select" name="loaiVe">
                    <option value="Hạng phổ thông">Hạng phổ thông</option>
                    <option value="Hạng thương gia">Hạng thương gia</option>
                </select>
            </div>
            <div class="mb-3">
                <label class="form-label">Giá vé (VNĐ)</label>
                <input type="number" class="form-control" name="giaVe" placeholder="Ví dụ: 90000" required/>
            </div>
            <div class="mb-3">
                <label class="form-label">Thông báo ghi chú</label>
                <input type="text" class="form-control" name="thongBao"/>
            </div>
            <button type="submit" class="btn btn-primary w-100">Xác Nhận Đặt Vé</button>
        </form>
    </div>
</div>
<jsp:include page="footer.jsp" />
</body>
</html>