CREATE DATABASE IF NOT EXISTS product CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE product;
SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS categories (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) UNIQUE NOT NULL,
    sort_order INT DEFAULT 0,
    created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
    updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS products (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price BIGINT NOT NULL,
    category_id BIGINT NOT NULL,
    image_url VARCHAR(500),
    status TINYINT DEFAULT 1,
    deleted_at DATETIME(3) NULL,
    created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
    updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
    INDEX idx_category_id (category_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS stocks (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    product_id BIGINT UNIQUE NOT NULL,
    quantity INT NOT NULL DEFAULT 0,
    version INT NOT NULL DEFAULT 0,
    updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS seckill_activities (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    product_id BIGINT NOT NULL,
    title VARCHAR(200) NOT NULL,
    seckill_price BIGINT NOT NULL,
    seckill_stock INT NOT NULL,
    status TINYINT NOT NULL DEFAULT 1,
    start_at DATETIME(3) NOT NULL,
    end_at DATETIME(3) NOT NULL,
    created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
    updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
    INDEX idx_product_id (product_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS product_option_groups (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    product_id BIGINT NOT NULL,
    name VARCHAR(100) NOT NULL,
    sort_order INT NOT NULL DEFAULT 0,
    created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
    updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
    INDEX idx_product_option_groups_product (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS product_option_values (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    group_id BIGINT NOT NULL,
    value VARCHAR(100) NOT NULL,
    sort_order INT NOT NULL DEFAULT 0,
    created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
    updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
    INDEX idx_product_option_values_group (group_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS product_skus (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    product_id BIGINT NOT NULL,
    sku_code VARCHAR(100) NOT NULL,
    title VARCHAR(200) NOT NULL,
    option_summary VARCHAR(255),
    price BIGINT NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    status TINYINT NOT NULL DEFAULT 1,
    sort_order INT NOT NULL DEFAULT 0,
    created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
    updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
    INDEX idx_product_skus_product (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS product_sku_option_values (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    sku_id BIGINT NOT NULL,
    option_value_id BIGINT NOT NULL,
    created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
    UNIQUE KEY uk_product_sku_option_value (sku_id, option_value_id),
    INDEX idx_sku_option (sku_id, option_value_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 基础类目测试数据：与当前精品电子商店前端导航保持一致。
INSERT INTO categories (id, name, sort_order) VALUES
    (1, 'Mac', 1),
    (2, 'iPhone', 2),
    (3, 'iPad', 3),
    (4, '穿戴', 4);

-- 商品测试数据说明：
-- 1. 商品名称、起售价和图片链接取自 Apple 中国官网公开页面。
-- 2. 用途仅限本地联调与界面测试，不作为正式业务主数据。
INSERT INTO products (id, name, description, price, category_id, image_url, status) VALUES
    (
        1001,
        'MacBook Air',
        '轻薄笔记本产品线测试数据，采用 MacBook Air 公开售价与公开商品图，适合首页与商品卡片陈列。',
        849900,
        1,
        'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/refurb-macbook-air-m2-midnight-202208?.v=QkJpMElmU3Z2QTUxaWlZMkpyNUtscEh6aWY2ZWN0VmhIWTdsdGVnU0taTWZPKzRGYmlpV2l6RFJ5NG1ZZysyZENTZE8vZlFNRjROdVREMHJZVDMwNkoxRWptQkFsR1F2c3A0cVVCbE5abTUvTGx1MitQcWg4T01uVGZzUyswZ1I&fmt=jpeg&hei=1144&qlt=90&wid=1144',
        1
    ),
    (
        1002,
        'iPhone 17 Pro',
        '高端旗舰手机测试数据，采用 iPhone 产品线公开起售价，并使用 Apple 官网公开机型展示图。',
        899900,
        2,
        'https://www.apple.com.cn/iphone/home/images/overview/consider/designed-to_last__f60bwgep88ya_large.jpg',
        1
    ),
    (
        1003,
        'iPad Air',
        '轻薄平板测试数据，采用 iPad Air 公开起售价与公开商品图，用于系列筛选和购物车链路测试。',
        479900,
        3,
        'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/ipad-compare-header-air-202405?.v=bk5Ha2llcUlIczRSRUt0WDVzK2I3aEp0T1lvbEU5VzVUeFMyYUl3ZjA1RVk2Q3FubUg5cC93VlMzQkExanhMSzAzOVFHb3N0MkVmS01ZcFh0d1Y4R2hvR0JUOE5DanRnclpMbkNkbll4VFE&fmt=png-alpha&hei=398&wid=392',
        1
    ),
    (
        1004,
        'AirPods Pro 2',
        '音频产品测试数据，采用 Apple 中国官网公开翻新页面价格与公开商品图，用于穿戴类展示与下单链路测试。',
        144900,
        4,
        'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/refurb-airpodspro-usbc-2024?.v=NXVzNnZ4ZXp0MHAyVndrdHZXbFYySUJOYzN0cHFuYlBISTdlQXVJQldpSmY3N0tLb1FmTGNNSGFlOE1lSXlmZ3VUb3VPa2FUZVhQMFhDQnVBMWhwQXdTUEllblZ5aUJzeHRFOUVuNEdYRGs&fmt=jpeg&hei=2000&qlt=90&wid=2000',
        1
    );

-- 为前端商品详情、购物车和后续下单 mock 提供可用库存。
INSERT INTO stocks (id, product_id, quantity, version) VALUES
    (1, 1001, 25, 0),
    (2, 1002, 40, 0),
    (3, 1003, 35, 0),
    (4, 1004, 60, 0);

-- SKU 规格测试数据说明：
-- 1. 以精品电子商品的典型选配维度构造最小 SKU 集；
-- 2. Product.price 继续承担列表起售价语义，SKU.price 才是最终成交价；
-- 3. 这些数据用于详情页、购物车和后续下单联调。
INSERT INTO product_option_groups (id, product_id, name, sort_order) VALUES
    (1101, 1001, '芯片', 1),
    (1102, 1001, '统一内存', 2),
    (1103, 1001, '存储', 3),
    (1201, 1002, '颜色', 1),
    (1202, 1002, '存储', 2),
    (1301, 1003, '颜色', 1),
    (1302, 1003, '存储', 2),
    (1401, 1004, '外观', 1);

INSERT INTO product_option_values (id, group_id, value, sort_order) VALUES
    (110101, 1101, 'M4', 1),
    (110201, 1102, '16GB', 1),
    (110301, 1103, '256GB', 1),
    (110302, 1103, '512GB', 2),
    (120101, 1201, '沙漠色', 1),
    (120102, 1201, '原色', 2),
    (120201, 1202, '256GB', 1),
    (120202, 1202, '512GB', 2),
    (130101, 1301, '深空灰', 1),
    (130102, 1301, '星光色', 2),
    (130201, 1302, '128GB', 1),
    (130202, 1302, '256GB', 2),
    (140101, 1401, 'USB-C 版', 1);

INSERT INTO product_skus (
    id,
    product_id,
    sku_code,
    title,
    option_summary,
    price,
    stock_quantity,
    status,
    sort_order
) VALUES
    (1001001, 1001, 'mba-m4-16-256', 'MacBook Air M4 16GB 256GB', 'M4 / 16GB / 256GB', 849900, 12, 1, 1),
    (1001002, 1001, 'mba-m4-16-512', 'MacBook Air M4 16GB 512GB', 'M4 / 16GB / 512GB', 999900, 8, 1, 2),
    (1002001, 1002, 'ip17pro-desert-256', 'iPhone 17 Pro 沙漠色 256GB', '沙漠色 / 256GB', 899900, 18, 1, 1),
    (1002002, 1002, 'ip17pro-natural-512', 'iPhone 17 Pro 原色 512GB', '原色 / 512GB', 1099900, 9, 1, 2),
    (1003001, 1003, 'ipadair-gray-128', 'iPad Air 深空灰 128GB', '深空灰 / 128GB', 479900, 15, 1, 1),
    (1003002, 1003, 'ipadair-starlight-256', 'iPad Air 星光色 256GB', '星光色 / 256GB', 599900, 10, 1, 2),
    (1004001, 1004, 'airpodspro2-usbc', 'AirPods Pro 2 USB-C 版', 'USB-C 版', 144900, 30, 1, 1);

INSERT INTO product_sku_option_values (sku_id, option_value_id) VALUES
    (1001001, 110101),
    (1001001, 110201),
    (1001001, 110301),
    (1001002, 110101),
    (1001002, 110201),
    (1001002, 110302),
    (1002001, 120101),
    (1002001, 120201),
    (1002002, 120102),
    (1002002, 120202),
    (1003001, 130101),
    (1003001, 130201),
    (1003002, 130102),
    (1003002, 130202),
    (1004001, 140101);

-- 秒杀活动测试数据：
-- 1. 使用已插入的精品电子商品作为活动载体；
-- 2. 时间窗故意覆盖较长区间，便于本地联调时直接命中“进行中”状态。
INSERT INTO seckill_activities (
    id,
    product_id,
    title,
    seckill_price,
    seckill_stock,
    status,
    start_at,
    end_at
) VALUES
    (
        1,
        1002,
        'iPhone 17 Pro 新品发售专场',
        869900,
        12,
        1,
        '2026-01-01 00:00:00.000',
        '2027-01-01 00:00:00.000'
    ),
    (
        2,
        1004,
        'AirPods Pro 2 限量精选活动',
        129900,
        20,
        1,
        '2026-01-01 00:00:00.000',
        '2027-01-01 00:00:00.000'
    );
