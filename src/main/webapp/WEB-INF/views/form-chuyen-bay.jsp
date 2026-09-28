<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Quản lý chuyến bay</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<jsp:include page="header.jsp" />
<div class="container mt-4">
    <a href="${pageContext.request.contextPath}/" class="btn btn-secondary mb-3">Quay lại Trang Chủ</a>
    <div class="card shadow-sm p-4">
        <h2 class="text-primary mb-4">Nhập Thông Tin Chuyến Bay</h2>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        <form action="${pageContext.request.contextPath}/chuyen-bay/save" method="post">
            <input type="hidden" name="maChuyenBay" value="${chuyenBay.maChuyenBay}"/>
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Số hiệu chuyến bay</label>
                    <input type="text" class="form-value form-control" name="soHieuChuyenBay" value="${chuyenBay.soHieuChuyenBay}" required/>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Trạng thái</label>
                    <select class="form-select" name="trangThai">
                        <option value="Đúng giờ" ${chuyenBay.trangThai == 'Đúng giờ' ? 'selected' : ''}>Đúng giờ</option>
                        <option value="Hoãn" ${chuyenBay.trangThai == 'Hoãn' ? 'selected' : ''}>Hoãn</option>
                        <option value="Hủy" ${chuyenBay.trangThai == 'Hủy' ? 'selected' : ''}>Hủy</option>
                    </select>
                </div>
            </div>
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Ngày giờ khởi hành</label>
                    <input type="datetime-local" class="form-control" name="ngayGioKhoiHanh" value="${chuyenBay.ngayGioKhoiHanh}" required/>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Ngày giờ đến</label>
                    <input type="datetime-local" class="form-control" name="ngayGioDen" value="${chuyenBay.ngayGioDen}" required/>
                </div>
            </div>
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Điểm khởi hành</label>
                    <input type="text" class="form-control" name="diemKhoiHanh" value="${chuyenBay.diemKhoiHanh}" required/>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Điểm đến</label>
                    <input type="text" class="form-control" name="diemDen" value="${chuyenBay.diemDen}" required/>
                </div>
            </div>
            <button type="submit" class="btn btn-success px-4">Lưu Thông Tin</button>
        </form>
    </div>

    <h3 class="mt-5 text-secondary">Danh Sách Chuyến Bay Hiện Tại</h3>
    <table class="table table-bordered table-striped mt-3 bg-white">
        <thead class="table-primary text-center">
        <tr>
            <th>Mã CB</th><th>Số hiệu</th><th>Khởi hành</th><th>Thời gian đến</th><th>Tuyến bay</th><th>Trạng thái</th><th>Thao tác</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="cb" items="${dsChuyenBay}">
            <tr>
                <td class="text-center">${cb.maChuyenBay}</td>
                <td>${cb.soHieuChuyenBay}</td>
                <td>${cb.ngayGioKhoiHanh}</td>
                <td>${cb.ngayGioDen}</td>
                <td>${cb.diemKhoiHanh} -> ${cb.diemDen}</td>
                <td class="text-center"><span class="badge ${cb.trangThai == 'Đúng giờ' ? 'bg-success' : 'bg-danger'}">${cb.trangThai}</span></td>
                <td class="text-center"><a href="${pageContext.request.contextPath}/chuyen-bay/edit/${cb.maChuyenBay}" class="btn btn-sm btn-warning">Đổi trạng thái</a></td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
<jsp:include page="footer.jsp" />
</body>
</html>