<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Hệ Thống Quản Lý Sân Bay</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<jsp:include page="header.jsp" />

<div class="container py-5 text-center">
    <div class="p-5 mb-4 bg-white rounded-3 shadow-sm border">
        <div class="container-fluid py-3">
            <h1 class="display-5 fw-bold text-primary mb-3">HỆ THỐNG QUẢN LÝ SÂN BAY</h1>
            <p class="col-md-8 mx-auto fs-5 text-secondary">
                Chào mừng bạn đến với trang quản trị hệ thống. Vui lòng lựa chọn các tính năng
                trên thanh điều hướng hoặc các phím tắt nhanh bên dưới để quản lý dữ liệu.
            </p>
            <hr class="my-4" style="max-width: 200px; margin: 0 auto;">

            <div class="d-flex justify-content-center gap-3 mt-4 flex-wrap">
                <a href="${pageContext.request.contextPath}/chuyen-bay/add" class="btn btn-outline-primary px-4">
                    <i class="fa-solid fa-plane me-1"></i> Vào Quản Lý Chuyến Bay
                </a>
                <a href="${pageContext.request.contextPath}/tim-kiem/ve" class="btn btn-outline-success px-4">
                    <i class="fa-solid fa-magnifying-glass me-1"></i> Đến Trang Tra Cứu Vé
                </a>
            </div>
        </div>
    </div>
</div>

<%-- Nhúng Footer dùng chung --%>
<jsp:include page="footer.jsp" />
</body>
</html>