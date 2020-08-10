USE examples;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(32) NOT NULL,
  `last_name` VARCHAR(32) NOT NULL,
  `age` TINYINT NULL DEFAULT NULL,
  `role` ENUM("USER","ADMIN") NOT NULL DEFAULT "USER",
  `email` varchar(255) NULL,
  `password` VARCHAR(1024) NOT NULL,
  `inscription_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY  (`first_name`,`last_name`)
);


CREATE TABLE `logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from` VARCHAR(255) NOT NULL,
  `origin` INT(11) NOT NULL,
  `time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX (`from`),
  INDEX (`origin`)
);

CREATE TABLE `articles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(64) NOT NULL,
  `description` VARCHAR(1024),
  `content` TEXT NOT NULL,
  `creation_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `creator_id` INT(11),
  PRIMARY KEY (`id`),
  FOREIGN KEY (`creator_id`) REFERENCES `users`(id)
);


CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` TEXT NOT NULL,
  `creation_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `article_id` INT(11) NOT NULL,
  `user_id` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`article_id`) REFERENCES `articles`(id),
  FOREIGN KEY (`user_id`) REFERENCES `users`(id)
);

CREATE TABLE `quotations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `note` TINYINT NOT NULL DEFAULT 0,
  `creation_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` INT(11) NOT NULL,
  `article_id` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(id),
  FOREIGN KEY (`article_id`) REFERENCES `articles`(id),
  UNIQUE KEY (`user_id`,`article_id`)
);

CREATE TABLE `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(64) NOT NULL,
  `creation_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

CREATE TABLE `categories_articles` (
  `category_id` INT(11) NOT NULL,
  `article_id` INT(11) NOT NULL,
  FOREIGN KEY (`category_id`) REFERENCES `categories`(id),
  FOREIGN KEY (`article_id`) REFERENCES `articles`(id),
  PRIMARY KEY (`category_id`,`article_id`)
);

START TRANSACTION;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Listage des données de la table examples.articles : ~2 rows (environ)
DELETE FROM `articles`;
/*!40000 ALTER TABLE `articles` DISABLE KEYS */;
INSERT INTO `articles` (`id`, `title`, `description`, `content`, `creation_date`, `creator_id`) VALUES
  (1, 'Augmentation des cas de covid-19 en belgique', NULL, 'Brussels Airlines a décidé de reporter l’extension de son plan de vol, prévue à partir du mois d’août, en raison d’un contexte financier difficile, ressort-il d’une note du CEO adressée au personnel de la compagnie aérienne. Brussels Airlines continuera donc à opérer avec deux appareils long courrier et 21 avions court courrier.', '2020-07-15 12:22:35', 1),
  (2, 'Nouvelle augmentation des cas de covid-19 en Belgique', NULL, 'Si l’augmentation des nouveaux cas peut s’observer sur tout le territoire, la Flandre concentre la majorité des cas, particulièrement à Anvers. En effet, le 20 juillet, on comptait 370 cas en Belgique, dont 283 cas en Flandre, 76% des cas nationaux donc. Sur l’ensemble de la Belgique, avec 370 cas le 20 juillet, on peut déjà considérer que le rebond de l’épidémie est présent. En effet, la dernière fois qu’une telle proportion de cas avait été rapportée c’était le 20 mai dernier. Mais c’est à Anvers que les chiffres semblent les plus impressionnants et peuvent poser la question d’une éventuelle deuxième vague. En effet, jamais les chiffres n’ont été aussi importants à Anvers, y compris pendant le pic de l’épidémie. Sur les 370 cas rapportés le 20 juillet, 179 se situaient dans la province d’Anvers (48% des cas totaux donc), dont 120 dans la ville d’Anvers (32%).', '2020-07-23 14:04:00', 1),
  (3, 'Première belge : un brumisateur qui tue le Covid-19 en 5 minutes', 'il est beau le brumisateur', 'La société Disinfect a présenté un nouveau concept permettant de désinfecter un espace de 1 000 m2 en heure.\r\n\r\nDe prime abord, le concept lancé par la société Disinfect semble constituer la solution idéale pour éradiquer tous les espaces clos de la moindre trace du Covid-19. Capable de désinfecter 1 000 m2 en heure, ce brumisateur mobile utilise de l’hypochlorite d’hydrogène, qu’il diffuse via deux tuyaux dirigés vers le plafond. Les deux flux de produit sont ensuite dispersés par un ventilateur.\r\n\r\nPrésentée en première belge hier dans une enseigne de la galerie Anspach, dans le centre de la capitale, cette solution 100 % naturelle peut même être diffusée en présence de la clientèle ou en présence d’employés si la brumisation se déroule dans des bureaux. Elle n’est nocive ni pour l’homme ni pour l’animal ni pour les produits alimentaires. Elle est d’ailleurs déjà utilisée aux Pays-Bas, sur des marchés couverts notamment.\r\n\r\n“Le produit est très simple à fabriquer”, explique le CEO de Disinfect Dieter Veulemans : “de l’eau, du sel, de l’hypochlorite d’hydrogène (HOCL) et une électrolyse. De plus, il est très bon marché : trois euros le litre dans le coût de l’eau. Les Chinois ont utilisé ce produit et ce mécanisme lors de l’épidémie de Sras”.', '2020-08-07 10:10:00', 4),
  (4, 'Coronavirus: le Royaume-Uni impose une quarantaine aux voyageurs', 'A partir de samedi, le Royaume-Uni imposera une quarantaine aux voyageurs en provenance de Belgique.', 'Le ministère des Transport britannique a annoncé jeudi que les voyageurs en provenance de Belgique, d\'Andorre ou des Bahamas seront à nouveau soumis à une quarantaine à partir de samedi, en raison d\'une "importante augmentation" des cas de nouveau coronavirus dans ces pays.\r\n\r\n"Les personnes arrivant en Angleterre depuis Andorre, la Belgique ou les Bahamas à partir du samedi 8 août à 4h00 du matin devront s\'isoler pendant deux semaines", précise le ministère dans un communiqué, qui a par ailleurs annoncé en même temps exempter les voyageurs en provenance du Brunei et de la Malaisie de ces mêmes mesures, à partir du 11 août.', '2020-08-07 10:10:00', 6),
  (5, 'Débats sur la mémoire du colonialisme', 'La commission spéciale de la Chambre qui se penche sur le passé colonial de la Belgique a choisi les dix experts scientifiques qui assisteront les parlementaires durant ses travaux, a indiqué jeudi son président, Wouter De Vriendt (Ecolo-Groen).', 'Le choix s\'est posé sur une équipe multidisciplinaire comprenant cinq historiens, des experts en (re)conciliation ainsi que des représentants de la diaspora congolaise. "Tous sont au sommet et ont mérité leurs galons", a commenté M. De Vriendt.\r\n\r\nIl s\'agit du Dr Zana Mathieu Etambala (Musée d\'Afrique et KULeuven), historien spécialisé dans l\'histoire coloniale, du Dr Gillian Mathys (UGent), historienne et chercheuse, du Pr Elikia M\'Bokolo (EHESS, Université Kinshasa), spécialiste de l\'histoire contemporaine et de l\'histoire de la diaspora africaine, d\'Anne Wetsi Mpoma, historienne de l\'art et membre de l\'association Bamko, de Mgr Jean-Louis Nahimana, ancien président de la commission Vérité et Réconciliation (CVR) burundaise.\r\n\r\nOn y retrouve aussi le Dr Pierre-Luc Plasman (UCL), historien et chercheur auprès de l\'Institut Sciences-Politiques Louvain-Europe, le Pr Valérie Rosoux (Institut Egmont et UCL), docteur en philosophie et relations internationales et spécialiste des processus de réconciliation, Martien Schotsmans, juriste avec une vaste expérience internationale dans les commission de réconciliation, ainsi que Laure Uwase, de nationalité rwandaise et avocate au barreau de Bruxelles et spécialiste de la région des Grands Lacs, et enfin, le Pr Sarah Van Beurden (Ohio State University), historienne spécialiste de l\'Afrique et de la culture coloniale.\r\n\r\nUn premier rapport intermédiaire de ces experts est attendu d\'ici octobre. Celui-ci fera le point sur l\'état des lieux de la recherche historique sur le passé colonial de la Belgique.\r\n\r\nLes commissaires procèderont ensuite à une série d\'auditions et autres travaux avant de rédiger leur rapport final reprenant leurs conclusions ainsi que des recommandations. Le délai programmé est d\'un an, mais prolongeable au besoin.\r\n\r\nEn vue de la réalisation de leur premier rapport intermédiaire, les experts ont été invités à prendre contact avec plusieurs personnalités de la diaspora congolaise. Il s\'agit ici notamment de Geneviève Kaninda (Collectif Mémoire Coloniale), de Suzanne Monkasa (présidente de la Plateforme des Femmes de la Diaspora congolaise de Belgique), de Tracy Tansia (Black Speaks Back), et d\'un représentant de Ibuka, une asbl qui regroupant des rescapés du génocide contre les Tutsi au Rwanda en 1994.', '2020-08-07 11:10:00', 8),
  (6, 'L\'incendie dans une tour du World Trade Center', 'L\'incendie qui s\'est déclaré jeudi après-midi vers 15h45 dans la tour WTC, située boulevard du roi Albert II, dans le quartier Nord à Bruxelles, a été maîtrisé dès 16h30, a indiqué le porte-parole des pompiers de Bruxelles Walter Derieuw.', 'Le bâtiment n\'est pas occupé pour le moment, car il fait l\'objet de travaux. Seuls des ouvriers étaient sur place quand l\'incendie s\'est déclaré. Ils ont évacué les lieux. Il n\'y a pas eu de blessé.\r\n\r\nL\'incendie est parti dans un local technique au 27e étage de la tour. C\'est du matériel d\'isolation qui a pris feu, ce qui génère beaucoup de fumée. Comme elle s\'échappait du sommet de la tour, l\'incendie était particulièrement visible.\r\n\r\nIl n\'y avait pas d\'eau dans la tour. Les pompiers sont montés jusqu\'à l\'étage en feu dans un conteneur soulevé par un monte-charge, manipulé par quatre ouvriers du chantier. Ils avaient avec eux des extincteurs et des lances à eau, qui ont été déployées une fois les pompiers hissés au sommet de la tour. L\'objectif était de se raccorder à l\'autopompe en bas. D\'autres postes voisins, notamment Zaventem et Vilvorde, ont été alertés pour assurer une alimentation en eau en suffisance.', '2020-08-07 08:10:00', 10),
  (7, 'Déclaration fiscale 2020 : Voici comment éviter les piège', ' Libre Eco- week-end : Spécial “Déclaration fiscale 2020” ', ' Depuis le 5 mai 2020, il est possible de remplir sa déclaration fiscale en ligne via Tax-On-Web, mais c’est dans le courant du mois de mai que les contribuables recevront la déclaration papier. Dans ce dossier, vous retrouverez des articles qui recensent de nombreux conseils, trucs et astuces qui vous permettront de remplir votre déclaration fiscale de la façon la plus efficace possible. Télétravail, voiture de société, déplacement, revenu de placements, abattement, revenus fonciers, frais forfaitaires, réduction d’impôt… : tous les sujets fiscaux sont abordés. Nous vous expliquons également ce qu\'est la déclaration fiscale simplifiée et comment la vérifier. ', '2020-07-03 08:10:00', 3);
/*!40000 ALTER TABLE `articles` ENABLE KEYS */;

-- Listage des données de la table examples.categories : ~5 rows (environ)
DELETE FROM `categories`;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` (`id`, `name`, `creation_date`) VALUES
  (1, 'Actualité', '2020-07-15 12:24:51'),
  (2, 'Politique', '2020-07-15 12:25:04'),
  (3, 'Divers', '2020-07-15 12:25:08'),
  (4, 'Economie', '2020-07-15 12:25:14'),
  (5, 'Nouvelles technologies', '2020-07-15 12:26:00');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;

-- Listage des données de la table examples.categories_articles : ~2 rows (environ)
DELETE FROM `categories_articles`;
/*!40000 ALTER TABLE `categories_articles` DISABLE KEYS */;
INSERT INTO `categories_articles` (`category_id`, `article_id`) VALUES
  (1, 1),
  (1, 2),
  (1, 3),
  (3, 3),
  (5, 3),
  (1, 4),
  (1, 5),
  (2, 5),
  (2, 6),
  (4, 7);
/*!40000 ALTER TABLE `categories_articles` ENABLE KEYS */;

-- Listage des données de la table examples.comments : ~5 rows (environ)
DELETE FROM `comments`;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
INSERT INTO `comments` (`id`, `content`, `creation_date`, `article_id`, `user_id`) VALUES
  (1, 'Je suis d\'accord', '2020-07-15 12:24:33', 1, 1),
  (2, 'Moi pas', '2020-07-16 12:24:33', 1, 2),
  (3, 'Portez votre masque !', '2020-07-23 15:00:00', 2, 2),
  (4, 'Encore un coup du gouvernement', '2020-07-24 20:00:00', 2, 3),
  (5, 'Bande de moutons', '2020-07-24 20:00:00', 2, 4),
  (6, 'Bonjour, abonnez vous à ma chaîne Youtube', '2020-07-24 20:00:00', 3, 5),
  (7, 'Bonjour, abonnez vous à ma chaîne Youtube', '2020-07-24 20:00:00', 4, 5),
  (8, 'Bonjour, abonnez vous à ma chaîne Youtube', '2020-07-24 20:00:00', 1, 5),
  (9, 'Bonjour, abonnez vous à ma chaîne Youtube', '2020-07-24 20:00:00', 7, 5),
  (10, 'T\'es viré Sébastien', '2020-07-24 20:00:00', 7, 6);
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;

-- Listage des données de la table examples.logs : ~0 rows (environ)
DELETE FROM `logs`;
/*!40000 ALTER TABLE `logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `logs` ENABLE KEYS */;

-- Listage des données de la table examples.quotations : ~1 rows (environ)
DELETE FROM `quotations`;
/*!40000 ALTER TABLE `quotations` DISABLE KEYS */;
INSERT INTO `quotations` (`id`, `note`, `creation_date`, `user_id`, `article_id`) VALUES
  (1, 4, '2020-07-15 12:23:45', 1, 1),
  (2, 3, '2020-07-15 12:23:45', 1, 2),
  (3, 2, '2020-07-15 12:23:45', 1, 3),
  (4, 1, '2020-07-15 12:23:45', 1, 4),
  (5, 5, '2020-07-15 12:23:45', 6, 4),
  (6, 4, '2020-07-15 12:23:45', 10, 7),
  (7, 3, '2020-07-15 12:23:45', 8, 7),
  (8, 2, '2020-07-15 12:23:45', 1, 7),
  (9, 1, '2020-07-15 12:23:45', 4, 3),
  (10, 4, '2020-07-15 12:23:45', 5, 6),
  (11, 0, '2020-07-15 12:23:45', 5, 7),
  (12, 0, '2020-07-15 12:23:45', 5, 1),
  (13, 3, '2020-07-15 12:23:45', 6, 1);
/*!40000 ALTER TABLE `quotations` ENABLE KEYS */;

-- Listage des données de la table examples.users : ~12 rows (environ)
DELETE FROM `users`;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`id`, `first_name`, `last_name`, `age`, `role`, `email`, `password`, `inscription_date`) VALUES
  (1, 'Léon', 'Douillet', 18, 'USER', 'plume@gmail.com', '6reg4r6e4gr64gre6g9r7g9er8g4r9e8erg4reg4er9', '2020-07-15 14:19:47'),
  (2, 'Loreal', 'Paris', 18, 'USER', NULL, 'ergjrjgroigjrgregvrovervnliovnerlvner', '2020-07-17 12:15:47'),
  (3, 'Amaury', 'Deflorenne', 22, 'ADMIN', 'amaury@gmail.com', 'fzejozeijfzeojfoezjfozeijfzeojfzeofj', '2019-09-26 08:00:00'),
  (4, 'Aurore', 'Deflorenne', 20, 'ADMIN', 'aurore@gmail.com', 'fzejozeijfzeojfoezjfozeijfzeojfzeofj', '2019-09-26 08:00:00'),
  (5, 'Sebastien', 'Cardon', 18, 'ADMIN', 'escardon@potato.com', 'gerggrgregergregergregergergerger', '2020-07-11 00:00:00'),
  (6, 'Gilles', 'Bertrand', 18, 'USER', 'gillesbertrant@triptyk.com', 'feojfojforiejoiergjreojgreojgoe', '2020-05-08 08:19:47'),
  (7, 'Guillaume', 'Danzin', 18, 'USER', 'danzinguilaumelegrand@triptyk.eu', 'gregrgregrvdfvvvregtrhthhtr', '2020-02-15 00:00:00'),
  (8, 'Morty', 'Smith', 18, 'USER', 'mortysmith@gmail.com', 'dfsxlsfdlkdppsdkfpsdfk', '2020-07-15 14:19:47'),
  (9, 'John', 'Smith', 20, 'USER', 'mortysmith@gmail.com', 'dfsxlsfdlkdppsdkfpsdfk', '2020-07-15 14:19:47'),
  (10, 'Henri', 'Smith', 30, 'USER', 'mortysmith@gmail.com', 'dfsxlsfdlkdppsdkfpsdfk', '2020-07-15 14:19:47'),
  (11, 'Potato', 'Smith', 30, 'USER', 'mortysmith@gmail.com', 'dfsxlsfdlkdppsdkfpsdfk', '2020-07-15 14:19:47'),
  (12, 'Rick', 'Sanchez', 18, 'USER', 'greenportal@gmail.com', 'dlgjlfgdfjdkfjgkdfjlgdfg', '2020-02-15 00:00:00');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;

COMMIT;