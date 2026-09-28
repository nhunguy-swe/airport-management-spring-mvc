<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Tìm kiếm hành khách</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<jsp:include page="header.jsp" />
<div class="container mt-4">
    <a href="${pageContext.request.contextPath}/" class="btn btn-secondary mb-3">Quay lại</a>

    <div class="card shadow-sm p-4 mb-4 bg-white rounded">
        <h3 class="text-primary fw-bold mb-4">Tra Cứu Thông Tin Hành Khách</h3>
        <form action="${pageContext.request.contextPath}/tim-kiem/khach-hang" method="get" class="row g-3">
            <div class="col-md-9">
                <input type="text" class="form-control" name="keyword"
                       placeholder="Nhập tên, số điện thoại hoặc email khách hàng..." value="${currentKeyword}"/>
            </div>
            <div class="col-md-3">
                <button type="submit" class="btn btn-primary w-100">Tìm Kiếm</button>
            </div>
        </form>
    </div>

    <div class="card shadow-sm p-3 bg-white">
        <h5 class="text-secondary mb-3">Danh sách kết quả khách hàng:</h5>
        <table class="table table-striped table-bordered table-hover align-middle mb-0">
            <thead class="table-dark text-center">
            <tr>
                <th style="width: 15%;">Mã KH</th>
                <th>Họ và Tên</th>
                <th>Số điện thoại</th>
                <th>Email</th>
            </tr>
            </thead>
            <tbody>
            <%-- Vòng lặp sẽ tự chạy nếu dsKetQua có dữ liệu --%>
            <c:forEach var="hk" items="${dsKetQua}">
                <tr>
                    <td class="text-center fw-bold text-secondary">${hk.maHanhKhach}</td>
                    <td>${hk.hoTen}</td>
                    <td class="text-center">${hk.soDienThoai}</td>
                    <td>${hk.email}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<jsp:include page="footer.jsp" />
</body>
</html>