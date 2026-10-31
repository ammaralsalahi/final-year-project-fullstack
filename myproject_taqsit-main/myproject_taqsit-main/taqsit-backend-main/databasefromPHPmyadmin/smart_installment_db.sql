-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: 09 مايو 2026 الساعة 18:35
-- إصدار الخادم: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `smart_installment_db`
--

-- --------------------------------------------------------

--
-- بنية الجدول `banks`
--

CREATE TABLE `banks` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `identity_number` varchar(255) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone_number` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `account_number` varchar(255) NOT NULL,
  `balance` decimal(15,2) NOT NULL DEFAULT 10000.00,
  `credit_score` int(11) NOT NULL DEFAULT 0,
  `max_credit_limit` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `banks`
--

INSERT INTO `banks` (`id`, `identity_number`, `full_name`, `email`, `phone_number`, `password`, `account_number`, `balance`, `credit_score`, `max_credit_limit`, `created_at`, `updated_at`) VALUES
(1, '1001001001', 'عمار ياسر الصلاحي', 'ammar@example.com', '777123456', '$2y$12$/L4x7JJXs8ZSDDrsC.soKOdJQWBjXMwumSLFBvThIs9R.dknP8H5q', 'ACC-2026-001', 50000.00, 100, 10000.00, '2026-05-08 11:13:25', '2026-05-08 11:18:11'),
(2, '1001001002', 'محمد أحمد الحضرمي', 'mohammed@example.com', '770111222', '$2y$12$eYJWKD8VStq5Spxyaf1Fxu3aWEm58Ig5SWMYQb8u.eMHD4ZYESIwu', 'ACC-2026-002', 15000.00, 85, 3000.00, '2026-05-08 11:18:11', '2026-05-08 11:18:11'),
(3, '1001001003', 'صالح علي اليافعي', 'saleh@example.com', '771333444', '$2y$12$Q./T0.5oJs5Daj5EfTOVzuyLH6Z6d75UXFeXpVpDEqetXkCLYnx0y', 'ACC-2026-003', 8000.00, 70, 1500.00, '2026-05-08 11:18:12', '2026-05-08 11:18:12'),
(4, '1001001004', 'فؤاد حسن التزي', 'fouad@example.com', '772555666', '$2y$12$tUIOyl6qUwcnPbfiBVXCXuWYVZLcfjyHDM57.CxYxcZTLUvrtV1DS', 'ACC-2026-004', 8333.33, 90, 0.00, '2026-05-08 11:18:12', '2026-05-09 11:46:08'),
(5, '1001001005', 'ناصر عبده الريمي', 'nasser@example.com', '773777888', '$2y$12$ckx1N.UkIAXxCGQoW/13ue7qQopPsYYZ5DFghY6ZBxMhAIkiv3Omm', 'ACC-2026-005', 3000.00, 45, 500.00, '2026-05-08 11:18:12', '2026-05-08 11:18:12');

-- --------------------------------------------------------

--
-- بنية الجدول `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- بنية الجدول `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- بنية الجدول `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- بنية الجدول `installments`
--

CREATE TABLE `installments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `due_date` date NOT NULL,
  `status` enum('pending','paid','late') NOT NULL DEFAULT 'pending',
  `paid_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `installments`
--

INSERT INTO `installments` (`id`, `order_id`, `user_id`, `amount`, `due_date`, `status`, `paid_at`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 16666.67, '2026-06-08', 'paid', '2026-05-08 11:13:25', '2026-05-08 11:13:25', '2026-05-08 11:13:25'),
(2, 1, 1, 16666.67, '2026-07-08', 'pending', NULL, '2026-05-08 11:13:25', '2026-05-08 11:13:25'),
(3, 1, 1, 16666.67, '2026-08-08', 'pending', NULL, '2026-05-08 11:13:25', '2026-05-08 11:13:25'),
(4, 2, 1, 1000.00, '2026-06-08', 'paid', '2026-05-08 11:13:26', '2026-05-08 11:13:26', '2026-05-08 11:13:26'),
(5, 2, 1, 1000.00, '2026-07-08', 'pending', NULL, '2026-05-08 11:13:26', '2026-05-08 11:13:26'),
(6, 2, 1, 1000.00, '2026-08-08', 'pending', NULL, '2026-05-08 11:13:26', '2026-05-08 11:13:26'),
(7, 3, 4, 1666.67, '2026-06-08', 'pending', NULL, '2026-05-08 12:16:45', '2026-05-08 12:16:45'),
(8, 3, 4, 1666.67, '2026-07-08', 'paid', '2026-05-09 11:42:43', '2026-05-08 12:16:45', '2026-05-09 11:42:43'),
(9, 3, 4, 1666.67, '2026-08-08', 'paid', '2026-05-09 11:46:08', '2026-05-08 12:16:45', '2026-05-09 11:46:08'),
(10, 4, 4, 1666.67, '2026-06-08', 'paid', '2026-05-08 12:55:37', '2026-05-08 12:34:22', '2026-05-08 12:55:37'),
(11, 4, 4, 1666.67, '2026-07-08', 'paid', '2026-05-08 13:01:57', '2026-05-08 12:34:22', '2026-05-08 13:01:57'),
(12, 4, 4, 1666.67, '2026-08-08', 'paid', '2026-05-08 13:06:05', '2026-05-08 12:34:22', '2026-05-08 13:06:05'),
(13, 4, 4, 1666.67, '2026-09-08', 'paid', '2026-05-09 11:20:45', '2026-05-08 12:34:22', '2026-05-09 11:20:45'),
(14, 4, 4, 1666.67, '2026-10-08', 'paid', '2026-05-09 11:23:45', '2026-05-08 12:34:22', '2026-05-09 11:23:45'),
(15, 4, 4, 1666.67, '2026-11-08', 'paid', '2026-05-09 11:37:08', '2026-05-08 12:34:22', '2026-05-09 11:37:08');

-- --------------------------------------------------------

--
-- بنية الجدول `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- بنية الجدول `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- بنية الجدول `merchants`
--

CREATE TABLE `merchants` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `store_name` varchar(255) NOT NULL,
  `commercial_reg` varchar(255) NOT NULL,
  `bank_account_number` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `bank_balance` decimal(15,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `merchants`
--

INSERT INTO `merchants` (`id`, `store_name`, `commercial_reg`, `bank_account_number`, `phone`, `bank_balance`, `created_at`, `updated_at`) VALUES
(1, 'المحضار للسيارات', 'CR-2024-001', 'BANK-01', '770000001', 0.00, '2026-05-08 11:13:25', '2026-05-08 11:13:25'),
(2, 'عالم الإلكترونيات', 'CR-2024-002', 'BANK-02', '770000002', 9800.00, '2026-05-08 11:13:25', '2026-05-08 12:16:45'),
(3, 'BMW', 'CR-2026-001', 'BANK-003', '717121928', 19600.00, '2026-05-08 11:46:34', '2026-05-08 12:34:22');

-- --------------------------------------------------------

--
-- بنية الجدول `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2026_04_28_142246_create_personal_access_tokens_table', 1),
(5, '2026_04_28_142532_create_merchants_table', 1),
(6, '2026_04_28_142547_create_products_table', 1),
(7, '2026_04_28_142558_create_orders_table', 1),
(8, '2026_04_28_142606_create_installments_table', 1),
(9, '2026_04_28_154224_create_transactions_table', 1),
(10, '2026_04_28_155340_create_banks_table', 1);

-- --------------------------------------------------------

--
-- بنية الجدول `orders`
--

CREATE TABLE `orders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `merchant_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `total_amount` decimal(15,2) NOT NULL,
  `down_payment` decimal(15,2) NOT NULL,
  `remaining_amount` decimal(15,2) NOT NULL,
  `commission_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `status` enum('pending','approved','rejected','completed','cancelled') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `merchant_id`, `product_id`, `total_amount`, `down_payment`, `remaining_amount`, `commission_amount`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, 100000.00, 50000.00, 50000.00, 3000.00, 'approved', '2026-05-08 11:13:25', '2026-05-08 11:13:25'),
(2, 1, 2, 2, 6000.00, 3000.00, 3000.00, 180.00, 'approved', '2026-05-08 11:13:25', '2026-05-08 11:13:25'),
(3, 4, 2, 4, 10000.00, 5000.00, 5000.00, 200.00, 'approved', '2026-05-08 12:16:45', '2026-05-08 12:16:45'),
(4, 4, 3, 5, 20000.00, 10000.00, 10000.00, 400.00, 'approved', '2026-05-08 12:34:22', '2026-05-08 12:34:22');

-- --------------------------------------------------------

--
-- بنية الجدول `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- بنية الجدول `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 4, 'auth_token', '9be9e29f651042786ee0f0f91d4bc936c5d30bf0aca7c3104772fa0f28a2a456', '[\"*\"]', '2026-05-08 12:12:08', NULL, '2026-05-08 12:08:06', '2026-05-08 12:12:08'),
(2, 'App\\Models\\User', 4, 'auth_token', 'd9e824f2a0198996836b13887ddf34f727053401af889ae41e0f72a77d717375', '[\"*\"]', '2026-05-08 12:16:45', NULL, '2026-05-08 12:16:23', '2026-05-08 12:16:45'),
(3, 'App\\Models\\User', 4, 'auth_token', 'c476101aa7bf3a30a52da5b0dcf2293d71a760cf6cf435987a02b49374faca05', '[\"*\"]', '2026-05-08 12:30:41', NULL, '2026-05-08 12:27:40', '2026-05-08 12:30:41'),
(4, 'App\\Models\\User', 4, 'auth_token', '6067b6250179ce0ee5ced7679594306781c69678ece184d5fc7c23164746a055', '[\"*\"]', '2026-05-08 12:49:47', NULL, '2026-05-08 12:30:59', '2026-05-08 12:49:47'),
(5, 'App\\Models\\User', 4, 'auth_token', '3e36953b4182f6fb841c3f6c71990a3cbd0894b672b74d3ee3bb5d42be0669ce', '[\"*\"]', '2026-05-08 12:55:37', NULL, '2026-05-08 12:53:22', '2026-05-08 12:55:37'),
(6, 'App\\Models\\User', 4, 'auth_token', '981246ab7bd83907b54aff201f7d6f2bace8e583873f81a804258f2a6ab6006f', '[\"*\"]', '2026-05-08 13:01:57', NULL, '2026-05-08 13:01:44', '2026-05-08 13:01:57'),
(7, 'App\\Models\\User', 4, 'auth_token', '0ef26bfb71cc02aec7637fc26394913abce85456cbd5c32a2a68fa281dc92c07', '[\"*\"]', NULL, NULL, '2026-05-08 13:02:07', '2026-05-08 13:02:07'),
(8, 'App\\Models\\User', 4, 'auth_token', '2da0364711fa5f9017731610499bab91bd49551705b6afd6b213b8a0e45ae543', '[\"*\"]', '2026-05-08 13:11:13', NULL, '2026-05-08 13:05:55', '2026-05-08 13:11:13'),
(9, 'App\\Models\\User', 4, 'auth_token', '9890ecc4c18d8abd2e97b4142ce26a1e1c02544567caca3bef60379fa97f41a8', '[\"*\"]', '2026-05-09 11:46:08', NULL, '2026-05-09 11:19:59', '2026-05-09 11:46:08'),
(10, 'App\\Models\\User', 4, 'auth_token', 'eef5daa3ea37d3cc004995f09073f627ed406d11dbd456a65e2398fa01ce59b7', '[\"*\"]', '2026-05-09 13:21:38', NULL, '2026-05-09 13:20:40', '2026-05-09 13:21:38');

-- --------------------------------------------------------

--
-- بنية الجدول `products`
--

CREATE TABLE `products` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `merchant_id` bigint(20) UNSIGNED NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(15,2) NOT NULL,
  `allow_installment` tinyint(1) NOT NULL DEFAULT 1,
  `image` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `products`
--

INSERT INTO `products` (`id`, `merchant_id`, `product_name`, `description`, `price`, `allow_installment`, `image`, `created_at`, `updated_at`) VALUES
(1, 1, 'تويوتا كامري 2024', 'منتج متاح بنظام التقسيط الذكي', 100000.00, 1, 'default.jpg', '2026-05-08 11:13:25', '2026-05-08 11:13:25'),
(2, 2, 'iPhone 15 Pro Max', 'منتج متاح بنظام التقسيط الذكي', 6000.00, 1, 'default.jpg', '2026-05-08 11:13:25', '2026-05-08 11:13:25'),
(3, 3, 'BMW', 'the  ultmie machine', 200000.00, 1, '1778251742_69fdf7de10cf7.jpg', '2026-05-08 11:49:02', '2026-05-08 11:49:02'),
(4, 2, 'headphones', 'افضل سماعات بالعالم', 10000.00, 1, '1778252858_69fdfc3a1cd42.png', '2026-05-08 12:07:38', '2026-05-08 12:07:38'),
(5, 3, 'bmw m2', 'bmw m2 twin turbo', 20000.00, 1, '1778253873_69fe0031327c0.jpg', '2026-05-08 12:24:33', '2026-05-08 12:24:53'),
(6, 2, 'gffff', 'sdfghjketl', 20000.00, 1, '1778343260_69ff5d5c842e5.png', '2026-05-09 13:14:20', '2026-05-09 13:14:20');

-- --------------------------------------------------------

--
-- بنية الجدول `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('KCkP394h4Za8eadm5QTQld1ASweDwlWJEWBGHnM2', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoicU5KdklTSlltdkY2UG5oaTJSbkdSZ2Yxc0tudWxwS1VYUDVFSUNKRSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzY6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9tZXJjaGFudC9sb2dpbiI7czo1OiJyb3V0ZSI7czoxOToibWVyY2hhbnQubG9naW4ucGFnZSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fXM6NTE6ImxvZ2luX2JhbmtfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aToxO3M6NTU6ImxvZ2luX21lcmNoYW50XzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6Mjt9', 1778343386);

-- --------------------------------------------------------

--
-- بنية الجدول `transactions`
--

CREATE TABLE `transactions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `from_party` varchar(255) NOT NULL,
  `to_party` varchar(255) NOT NULL,
  `reference_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `transactions`
--

INSERT INTO `transactions` (`id`, `user_id`, `order_id`, `type`, `amount`, `from_party`, `to_party`, `reference_id`, `created_at`, `updated_at`) VALUES
(1, 4, 3, 'purchase_down_payment', 5000.00, 'User Account: فؤاد حسن التزي', 'Merchant Store: عالم الإلكترونيات', NULL, '2026-05-08 12:16:45', '2026-05-08 12:16:45'),
(2, 4, 4, 'purchase_down_payment', 10000.00, 'حساب العميل: فؤاد حسن التزي', 'متجر التاجر: BMW', NULL, '2026-05-08 12:34:22', '2026-05-08 12:34:22'),
(3, 4, 4, 'installment_payment', 1666.67, 'Customer Account', 'Smart Installment System', NULL, '2026-05-08 12:55:37', '2026-05-08 12:55:37'),
(4, 4, 4, 'installment_payment', 1666.67, 'Customer Account', 'Smart Installment System', NULL, '2026-05-08 13:01:57', '2026-05-08 13:01:57'),
(5, 4, 4, 'installment_payment', 1666.67, 'Customer Account', 'Smart Installment System', NULL, '2026-05-08 13:06:05', '2026-05-08 13:06:05'),
(6, 4, 4, 'installment_payment', 1666.67, 'Customer Account', 'Smart Installment System', NULL, '2026-05-09 11:20:45', '2026-05-09 11:20:45'),
(7, 4, 4, 'installment_payment', 1666.67, 'Customer Account', 'Smart Installment System', NULL, '2026-05-09 11:23:45', '2026-05-09 11:23:45'),
(8, 4, 4, 'installment_payment', 1666.67, 'Customer Account', 'Smart Installment System', NULL, '2026-05-09 11:37:08', '2026-05-09 11:37:08'),
(9, 4, 3, 'installment_payment', 1666.67, 'Customer Account', 'Smart Installment System', NULL, '2026-05-09 11:42:43', '2026-05-09 11:42:43'),
(10, 4, 3, 'installment_payment', 1666.67, 'Customer Account', 'Smart Installment System', NULL, '2026-05-09 11:46:08', '2026-05-09 11:46:08');

-- --------------------------------------------------------

--
-- بنية الجدول `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `phone_number` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `is_blocked` tinyint(1) NOT NULL DEFAULT 0,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `users`
--

INSERT INTO `users` (`id`, `full_name`, `phone_number`, `password`, `address`, `is_active`, `is_blocked`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'عمار ياسر الصلاحي', '777123456', '$2y$12$/L4x7JJXs8ZSDDrsC.soKOdJQWBjXMwumSLFBvThIs9R.dknP8H5q', NULL, 1, 0, NULL, '2026-05-08 11:13:25', '2026-05-08 11:18:11'),
(2, 'محمد أحمد الحضرمي', '770111222', '$2y$12$eYJWKD8VStq5Spxyaf1Fxu3aWEm58Ig5SWMYQb8u.eMHD4ZYESIwu', NULL, 1, 0, NULL, '2026-05-08 11:18:11', '2026-05-08 11:18:11'),
(3, 'صالح علي اليافعي', '771333444', '$2y$12$Q./T0.5oJs5Daj5EfTOVzuyLH6Z6d75UXFeXpVpDEqetXkCLYnx0y', NULL, 1, 0, NULL, '2026-05-08 11:18:12', '2026-05-08 11:18:12'),
(4, 'فؤاد حسن التزي', '772555666', '$2y$12$tUIOyl6qUwcnPbfiBVXCXuWYVZLcfjyHDM57.CxYxcZTLUvrtV1DS', NULL, 1, 0, NULL, '2026-05-08 11:18:12', '2026-05-09 11:46:08'),
(5, 'ناصر عبده الريمي', '773777888', '$2y$12$ckx1N.UkIAXxCGQoW/13ue7qQopPsYYZ5DFghY6ZBxMhAIkiv3Omm', NULL, 1, 0, NULL, '2026-05-08 11:18:12', '2026-05-08 11:18:12');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `banks`
--
ALTER TABLE `banks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `banks_identity_number_unique` (`identity_number`),
  ADD UNIQUE KEY `banks_email_unique` (`email`),
  ADD UNIQUE KEY `banks_phone_number_unique` (`phone_number`),
  ADD UNIQUE KEY `banks_account_number_unique` (`account_number`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `installments`
--
ALTER TABLE `installments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `installments_order_id_foreign` (`order_id`),
  ADD KEY `installments_user_id_foreign` (`user_id`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `merchants`
--
ALTER TABLE `merchants`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `merchants_commercial_reg_unique` (`commercial_reg`),
  ADD UNIQUE KEY `merchants_bank_account_number_unique` (`bank_account_number`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `orders_user_id_foreign` (`user_id`),
  ADD KEY `orders_merchant_id_foreign` (`merchant_id`),
  ADD KEY `orders_product_id_foreign` (`product_id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `products_merchant_id_foreign` (`merchant_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `transactions_user_id_foreign` (`user_id`),
  ADD KEY `transactions_order_id_foreign` (`order_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_phone_number_unique` (`phone_number`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `banks`
--
ALTER TABLE `banks`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `installments`
--
ALTER TABLE `installments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `merchants`
--
ALTER TABLE `merchants`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- قيود الجداول المُلقاة.
--

--
-- قيود الجداول `banks`
--
ALTER TABLE `banks`
  ADD CONSTRAINT `banks_phone_number_foreign` FOREIGN KEY (`phone_number`) REFERENCES `users` (`phone_number`) ON DELETE CASCADE;

--
-- قيود الجداول `installments`
--
ALTER TABLE `installments`
  ADD CONSTRAINT `installments_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `installments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- قيود الجداول `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_merchant_id_foreign` FOREIGN KEY (`merchant_id`) REFERENCES `merchants` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `orders_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- قيود الجداول `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_merchant_id_foreign` FOREIGN KEY (`merchant_id`) REFERENCES `merchants` (`id`) ON DELETE CASCADE;

--
-- قيود الجداول `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `transactions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
