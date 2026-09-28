<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Tra cứu vé máy bay</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<jsp:include page="header.jsp" />
<div class="container mt-4">
    <a href="${pageContext.request.contextPath}/" class="btn btn-secondary mb-3">Quay lại</a>

    <div class="card shadow-sm p-4 mb-4 bg-white rounded">
        <h3 class="text-primary fw-bold mb-4">Tra Cứu Vé Máy Báy</h3>
        <form action="${pageContext.request.contextPath}/tim-kiem/ve" method="get" class="row g-3">
            <div class="col-md-5">
                <input type="text" class="form-control" name="soHieu"
                       placeholder="Số hiệu chuyến bay..." value="${currentSoHieu}"/>
            </div>
            <div class="col-md-4">
                <select class="form-select" name="loaiVe">
                    <option value="">-- Tất cả hạng vé --</option>
                    <option value="Hạng phổ thông" ${currentLoaiVe == 'Hạng phổ thông' ? 'selected' : ''}>Hạng phổ thông</option>
                    <option value="Hạng thương gia" ${currentLoaiVe == 'Hạng thương gia' ? 'selected' : ''}>Hạng thương gia</option>
                </select>
            </div>
            <div class="col-md-3">
                <button type="submit" class="btn btn-primary w-100">Tìm Kiếm</button>
            </div>
        </form>
    </div>

    <div class="card shadow-sm p-3 bg-white">
        <h5 class="text-secondary mb-3">Danh sách kết quả vé:</h5>
        <table class="table table-striped table-bordered table-hover align-middle mb-0">
            <thead class="table-primary text-center">
            <tr>
                <th style="width: 10%;">Mã Vé</th>
                <th>Hành Khách</th>
                <th>Số Hiệu Chuyến</th>
                <th>Loại Vé</th>
                <th>Giá Vé</th>
                <th>Thông Báo</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="v" items="${dsKetQua}">
                <tr>
                    <td class="text-center fw-bold text-secondary">${v.maVe}</td>
                    <td><c:out value="${v.hanhKhach.hoTen}" default="N/A"/></td>
                    <td class="text-center fw-bold text-primary">${v.chuyenBay.soHieuChuyenBay}</td>
                    <td>${v.loaiVe}</td>
                    <td class="text-end fw-bold text-danger">${v.giaVe} VNĐ</td>
                    <td><span class="badge bg-warning text-dark">${v.thongBao}</span></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<jsp:include page="footer.jsp" />
</body>
</html>