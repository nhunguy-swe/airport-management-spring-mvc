<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hệ Thống Quản Lý Sân Bay</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body class="d-flex flex-column min-vh-100 bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm mb-4">
    <div class="container">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/">
            <i class="fa-solid fa-plane-departure me-2"></i>Airport Management
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item">
                    <a class="nav-link text-white" href="${pageContext.request.contextPath}/chuyen-bay/add">
                        <i class="fa-solid fa-plane me-1"></i> Chuyến Bay
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white" href="${pageContext.request.contextPath}/hanh-khach/add">
                        <i class="fa-solid fa-users me-1"></i> Hành Khách
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white" href="${pageContext.request.contextPath}/ve/add">
                        <i class="fa-solid fa-ticket me-1"></i> Vé Máy Bay
                    </a>
                </li>
                <li class="nav-item ms-lg-2">
                    <a class="btn btn-warning btn-sm my-1 my-lg-0 me-2 text-dark fw-bold" href="${pageContext.request.contextPath}/tim-kiem/khach-hang">
                        <i class="fa fa-search"></i> Tìm Khách
                    </a>
                </li>
                <li class="nav-item">
                    <a class="btn btn-warning btn-sm my-1 my-lg-0 text-dark fw-bold" href="${pageContext.request.contextPath}/tim-kiem/ve">
                        <i class="fa fa-search"></i> Tìm Vé
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<main class="flex-grow-1"/>