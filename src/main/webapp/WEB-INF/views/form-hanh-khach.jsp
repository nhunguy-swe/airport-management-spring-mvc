<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Thêm Hành Khách</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<jsp:include page="header.jsp" />
<div class="container mt-5" style="max-width: 600px;">
    <a href="${pageContext.request.contextPath}/" class="btn btn-secondary mb-3">Quay lại</a>
    <div class="card shadow p-4">
        <h2 class="text-success mb-4 text-center">Đăng Ký Hành Khách</h2>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        <c:if test="${param.success}">
            <div class="alert alert-success">Thêm hành khách thành công!</div>
        </c:if>
        <form action="${pageContext.request.contextPath}/hanh-khach/save" method="post">
            <div class="mb-3">
                <label class="form-label">Họ tên hành khách</label>
                <input type="text" class="form-control" name="hoTen" required/>
            </div>
            <div class="mb-3">
                <label class="form-label">Số điện thoại</label>
                <input type="text" class="form-control" name="soDienThoai" placeholder="Ví dụ: 0912345678" required/>
            </div>
            <div class="mb-3">
                <label class="form-label">Email</label>
                <input type="email" class="form-control" name="email" required/>
            </div>
            <button type="submit" class="btn btn-success w-100">Lưu dữ liệu</button>
        </form>
    </div>
</div>
<jsp:include page="footer.jsp" />
</body>
</html>