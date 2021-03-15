CREATE TABLE `inventories` (
  `id` varchar(64) NOT NULL,
  `data` longtext NOT NULL DEFAULT '[]'
);

CREATE TABLE `users` (
  `userId` int(11) NOT NULL,
  `userData` longtext NOT NULL DEFAULT '[]',
  `userIdentifiers` longtext NOT NULL DEFAULT '[]',
  `registeredDate` date NOT NULL
);

ALTER TABLE `inventories`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `users`
  ADD PRIMARY KEY (`userId`);

ALTER TABLE `users`
  MODIFY `userId` int(11) NOT NULL AUTO_INCREMENT;
