-- 1. Chuyển sang database chuẩn của bài mới
USE webst3;
GO

-- 2. Thêm Roles mẫu (ROLE_ADMIN và ROLE_USER)
IF NOT EXISTS (SELECT 1 FROM roles WHERE name = 'ROLE_ADMIN')
BEGIN
    INSERT INTO roles (name) VALUES ('ROLE_ADMIN');
END
GO

IF NOT EXISTS (SELECT 1 FROM roles WHERE name = 'ROLE_USER')
BEGIN
    INSERT INTO roles (name) VALUES ('ROLE_USER');
END
GO

-- 3. Thêm tài khoản mẫu đã kích hoạt (enabled = 1)
-- Mật khẩu mặc định là: 123456 (đã mã hóa BCrypt)
DECLARE @AdminRoleId BIGINT = (SELECT id FROM roles WHERE name = 'ROLE_ADMIN');
DECLARE @UserRoleId BIGINT = (SELECT id FROM roles WHERE name = 'ROLE_USER');

-- Tạo Admin (username: admin)
IF NOT EXISTS (SELECT 1 FROM users WHERE username = 'admin')
BEGIN
    INSERT INTO users (username, email, password, fullName, images, enabled, role_id)
    VALUES (
        'admin', 
        'admin@gmail.com', 
        '$2a$10$e8T7XnK7o4s4D4oJp6y0ce7x4K5L8a3J1q9W6e2R4t6Y8u0I2o4Pa', 
        N'Nguyễn Hữu Trung', 
        NULL, 
        1, 
        @AdminRoleId
    );
END

-- Tạo User thường (username: user1)
IF NOT EXISTS (SELECT 1 FROM users WHERE username = 'user1')
BEGIN
    INSERT INTO users (username, email, password, fullName, images, enabled, role_id)
    VALUES (
        'user1', 
        'user1@gmail.com', 
        '$2a$10$e8T7XnK7o4s4D4oJp6y0ce7x4K5L8a3J1q9W6e2R4t6Y8u0I2o4Pa', 
        N'Trần Văn A', 
        NULL, 
        1, 
        @UserRoleId
    );
END
GO

-- 4. Thêm sản phẩm mẫu (khóa ngoại trỏ sang user_id)
DECLARE @UserId BIGINT = (SELECT TOP 1 id FROM users WHERE username = 'admin');

-- Nếu không tìm thấy admin thì lấy bất kỳ user nào đầu tiên
IF (@UserId IS NULL)
BEGIN
    SET @UserId = (SELECT TOP 1 id FROM users);
END

IF (@UserId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM products))
BEGIN
    INSERT INTO products (name, description, price, imageUrl, user_id, createdAt) 
    VALUES 
    (N'iPhone 15 Pro Max', N'Điện thoại Apple cao cấp nhất', 30000000.00, 'https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=500', @UserId, GETDATE()),
    (N'Samsung Galaxy S24 Ultra', N'Flagship Samsung tích hợp Galaxy AI', 28000000.00, 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=500', @UserId, GETDATE()),
    (N'MacBook Air M2', N'Laptop mỏng nhẹ, pin cực trâu', 24000000.00, 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500', @UserId, GETDATE()),
    (N'Dell XPS 13', N'Màn hình vô cực, chuẩn doanh nhân', 26000000.00, 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?w=500', @UserId, GETDATE()),
    (N'Asus ROG Zephyrus', N'Cỗ máy Gaming đồ họa đỉnh cao', 35000000.00, 'https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=500', @UserId, GETDATE()),
    (N'Xiaomi 14 Pro', N'Ống kính Leica sắc nét', 18000000.00, 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500', @UserId, GETDATE()),
    (N'iPad Air 5 M1', N'Tablet mạnh mẽ cho sáng tạo nội dung', 15000000.00, 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=500', @UserId, GETDATE());
END
GO