-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 26, 2024 at 07:36 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `news_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `live_news`
--

CREATE TABLE `live_news` (
  `id` int(11) NOT NULL,
  `live_news_link` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `news`
--

CREATE TABLE `news` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `sub_title` varchar(255) NOT NULL,
  `news_source` varchar(255) NOT NULL,
  `news_detail` longtext NOT NULL,
  `is_featured` tinyint(1) NOT NULL,
  `is_top_story` tinyint(1) NOT NULL,
  `is_video` tinyint(1) NOT NULL,
  `is_video_of_the_day` tinyint(1) NOT NULL,
  `video_link` varchar(255) DEFAULT NULL,
  `topic_id` int(11) DEFAULT NULL,
  `sub_topic_id` int(11) NOT NULL DEFAULT 0,
  `news_photo` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `news`
--

INSERT INTO `news` (`id`, `title`, `sub_title`, `news_source`, `news_detail`, `is_featured`, `is_top_story`, `is_video`, `is_video_of_the_day`, `video_link`, `topic_id`, `sub_topic_id`, `news_photo`) VALUES
(10, 'new news ', 'نداء الوطن: بشرى حافظ الأسد ونجلها غادرا عبر مطار بيروت | لقراءة المقال كاملاً', 'al jaded ', '<p>داء الوطن: بشرى حافظ الأسد ونجلها غادرا عبر مطار بيروت<br />\r\n<br />\r\nكتبت صحيفة &quot;نداء الوطن&quot;: منذ أن أثارت نداء الوطن قضية أو فضيحة دخول مسؤولين من النظام السوري المخلوع، أو من عائلاتهم، عبر الحدود اللبنانية، والسفر عبر مطار بيروت، أو المكوث في لبنان، بأسماء مستعارة، حتى قامت القيامة ولم تقعد لليوم الثالث على التوالي. وما ضاعف من هذه القضية، البلبلة التي قابلت بها السلطات الرسمية المختصة هذا الملف، بحيث بدت عاجزة عن إعطاء أجوبة كافية ووافية ومنطقية حيال ما جرى. لم تقل السلطة، على سبيل المثال لا الحصر، ما هي الاعتبارات التي أملت تغيير ضابط الأمن العام على معبر المصنع، أحمد نكد، واستبداله بالضابط إيهاب الديراني؟ وما هي الأخطاء الجسيمة التي ارتكبها نكد والتي استدعت نقله من منصبه الحساس؟ وهل اقتصر الأمر على إبعاده من منصبه، أم ترافق الإبعاد مع عقوبات مسلكية؟ في سياق قضية دخول السوريين الملاحقين إلى لبنان، علمت نداء الوطن أن اللواءين علي مملوك وغسان نافع بلال مدير مكتب ماهر الأسد، دخلا إلى لبنان عبر معبر غير شرعي وسافرا إلى دولة عربية، كذلك فإن شقيقة الرئيس المخلوع بشار الأسد، بشرى، كانت في سوريا مع ابنها باسل، وأيضاً غادرا عبر مطار بيروت كونهما يملكان جوازي سفر غير الجوازين السوريين، الجدير ذكره أن زوج بشرى، اللواء آصف شوكت، نائب وزير الدفاع، كان اغتيل في انفجار أحد الاجتماعات الأمنية في دمشق.<br />\r\n&nbsp;</p>\r\n\r\n<p>وفي ملف مرتبط بما حدث في المصنع، استفاقة سنية طالبت باستعادة المركز الذي كان يترأسه ضابط سني قبل أن يتم وضع اليد عليه كغيره من المراكز، وهو منصب ساد العرف أن يتسلمه أحد الضباط من منطقة البقاع الغربي ولا سيما مجدل عنجر أو بر الياس، وهو ما دفع أهالي المنطقة يوم الثلثاء إلى التظاهر والمطالبة بإعادته إلى هاتين المنطقتين، بعد الضجة التي أثيرت حوله، واعتبارهم مرور أتباع النظام عبره استفزازاً لهم، ولم يوفروا أحداً من أبناء الطائفة إلا وكان له ملفٌ عندهم.<br />\r\n<br />\r\nوتقول المعلومات إن إسناد رئاسة المركز إلى ضابط سني من الأمن العام عملاً بالتوزيع الطائفي في المراكز بات جاهزاً.<br />\r\n<br />\r\nالأمن العام دافع عن إجراءاته فأعلن أنه نتيجة للأوضاع السورية المستجدة، يشهد معبر المصنع تدفقاً لعدد كبير من الوافدين السوريين، ويقوم الجيش والأمن العام باتخاذ الاجراءات لمنع وصولهم إلى الحدود قبل التأكد من استيفائهم شروط الدخول إلى لبنان، الأمر الذي تسبب بزحمة سير على الطريق الدولي لعدة أيام. وأن الاكتظاظ الشعبي ليس فلتاناً وفوضى، بل نتيجة للتشدد في الإجراءات المتخذة قبل الوصول إلى مركز الأمن العام .<br />\r\n<br />\r\nلم يتطرق بيان الأمن العام.....</p>\r\n', 1, 1, 1, 1, 'https://youtu.be/E571YZb_k00?si=MKGs4j4h_V739vfi', 15, 15, '/h2hagqnk.jpeg');

-- --------------------------------------------------------

--
-- Table structure for table `sub_topic`
--

CREATE TABLE `sub_topic` (
  `id` int(11) NOT NULL,
  `sub_topic_name` varchar(255) NOT NULL,
  `topic_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `sub_topic`
--

INSERT INTO `sub_topic` (`id`, `sub_topic_name`, `topic_id`) VALUES
(5, 'Video shows Israeli strike collapse multi-storey building in Beirut', 11),
(6, 'Video shows Israeli strike collapse multi-storey building in Beirut', 12),
(7, 'Video shows Israeli strike collapse multi-storey building in Beirut', 13),
(8, 'nataniaho house ', 14),
(9, 'نداء الوطن: بشرى حافظ الأسد ونجلها غادرا عبر مطار بيروت | لقراءة المقال كاملاً', 15);

-- --------------------------------------------------------

--
-- Table structure for table `topic`
--

CREATE TABLE `topic` (
  `id` int(11) NOT NULL,
  `topic_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `topic`
--

INSERT INTO `topic` (`id`, `topic_name`) VALUES
(15, 'lebanon');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `created_at`) VALUES
(1, 'jawad@gmail.com', 'jawadof5277', '2024-10-25 13:30:07');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `live_news`
--
ALTER TABLE `live_news`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `news`
--
ALTER TABLE `news`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sub_topic`
--
ALTER TABLE `sub_topic`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `topic`
--
ALTER TABLE `topic`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `live_news`
--
ALTER TABLE `live_news`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `news`
--
ALTER TABLE `news`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `sub_topic`
--
ALTER TABLE `sub_topic`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `topic`
--
ALTER TABLE `topic`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
