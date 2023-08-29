create
    database easybank;

use
    easybank;

DROP TABLE users;
DROP TABLE authorities;
DROP TABLE customer;

CREATE TABLE customer
(
    customer_id   INT          NOT NULL AUTO_INCREMENT,
    name          VARCHAR(100) NOT NULL,
    email         VARCHAR(100) NOT NULL UNIQUE,
    mobile_number VARCHAR(20)  NOT NULL,
    pwd           VARCHAR(500) NOT NULL,
    role          VARCHAR(100) NOT NULL,
    create_dt     DATE DEFAULT NULL,
    PRIMARY KEY (customer_id)
);

INSERT INTO customer(name, email, mobile_number, pwd, role, create_dt)
VALUES ('Happy', 'happy@yopmail.com', '4354656',
        '$2a$10$vUi9lXSiRiRPjP9qbmPrVeQU7pkO8BkgVJVtWLt2h2XV6cOuY', 'admin',
        CURDATE());

CREATE TABLE accounts
(
    customer_id    INT          NOT NULL,
    account_number INT          NOT NULL,
    account_type   VARCHAR(100) NOT NULL,
    branch_address VARCHAR(200) NOT NULL,
    create_dt      DATE DEFAULT NULL,
    PRIMARY KEY (account_number),
    KEY customer_id (customer_id),
    CONSTRAINT customer_ibfk_1 FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE CASCADE
);

INSERT INTO accounts(customer_id, account_number, account_type, branch_address, create_dt)
VALUES (1, 1865764534, 'Savings', '123 Main Street, New York', CURDATE());

CREATE TABLE account_transactions
(
    transaction_id      VARCHAR(200) NOT NULL,
    account_number      INT          NOT NULL,
    customer_id         INT          NOT NULL,
    transaction_dt      DATE         NOT NULL,
    transaction_summary VARCHAR(200) NOT NULL,
    transaction_type    VARCHAR(100) NOT NULL,
    transaction_amt     INT          NOT NULL,
    closing_balance     INT          NOT NULL,
    create_dt           DATE DEFAULT NULL,
    PRIMARY KEY (transaction_id),
    KEY customer_id (customer_id),
    KEY account_number (account_number),
    CONSTRAINT accounts_ibfk_2 FOREIGN KEY (account_number) REFERENCES accounts (account_number) ON DELETE CASCADE,
    CONSTRAINT acct_user_ibfk_1 FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE CASCADE
);


INSERT INTO `account_transactions` (`transaction_id`, `account_number`, `customer_id`, `transaction_dt`,
                                    `transaction_summary`, `transaction_type`, `transaction_amt`,
                                    `closing_balance`, `create_dt`)
VALUES (UUID(), 1865764534, 1, DATE_SUB(CURDATE(), INTERVAL 7 DAY), 'Coffee Shop', 'Withdrawal', 30, 34500,
        DATE_SUB(CURDATE(), INTERVAL 7 DAY));

INSERT INTO `account_transactions` (`transaction_id`, `account_number`, `customer_id`, `transaction_dt`,
                                    `transaction_summary`, `transaction_type`, `transaction_amt`,
                                    `closing_balance`, `create_dt`)
VALUES (UUID(), 1865764534, 1, DATE_SUB(CURDATE(), INTERVAL 6 DAY), 'Uber', 'Withdrawal', 100, 34400,
        DATE_SUB(CURDATE(), INTERVAL 6 DAY));

INSERT INTO `account_transactions` (`transaction_id`, `account_number`, `customer_id`, `transaction_dt`,
                                    `transaction_summary`, `transaction_type`, `transaction_amt`,
                                    `closing_balance`, `create_dt`)
VALUES (UUID(), 1865764534, 1, DATE_SUB(CURDATE(), INTERVAL 5 DAY), 'Self Deposit', 'Deposit', 500, 34900,
        DATE_SUB(CURDATE(), INTERVAL 5 DAY));

INSERT INTO `account_transactions` (`transaction_id`, `account_number`, `customer_id`, `transaction_dt`,
                                    `transaction_summary`, `transaction_type`, `transaction_amt`,
                                    `closing_balance`, `create_dt`)
VALUES (UUID(), 1865764534, 1, DATE_SUB(CURDATE(), INTERVAL 4 DAY), 'Ebay', 'Withdrawal', 600, 34300,
        DATE_SUB(CURDATE(), INTERVAL 4 DAY));

INSERT INTO `account_transactions` (`transaction_id`, `account_number`, `customer_id`, `transaction_dt`,
                                    `transaction_summary`, `transaction_type`, `transaction_amt`,
                                    `closing_balance`, `create_dt`)
VALUES (UUID(), 1865764534, 1, DATE_SUB(CURDATE(), INTERVAL 2 DAY), 'OnlineTransfer', 'Deposit', 700, 35000,
        DATE_SUB(CURDATE(), INTERVAL 2 DAY));

INSERT INTO `account_transactions` (`transaction_id`, `account_number`, `customer_id`, `transaction_dt`,
                                    `transaction_summary`, `transaction_type`, `transaction_amt`,
                                    `closing_balance`, `create_dt`)
VALUES (UUID(), 1865764534, 1, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 'Amazon.com', 'Withdrawal', 100, 34900,
        DATE_SUB(CURDATE(), INTERVAL 1 DAY));


CREATE TABLE `loans`
(
    `loan_number`        int          NOT NULL AUTO_INCREMENT,
    `customer_id`        int          NOT NULL,
    `start_dt`           date         NOT NULL,
    `loan_type`          varchar(100) NOT NULL,
    `total_loan`         int          NOT NULL,
    `amount_paid`        int          NOT NULL,
    `outstanding_amount` int          NOT NULL,
    `create_dt`          date DEFAULT NULL,
    PRIMARY KEY (`loan_number`),
    KEY `customer_id` (`customer_id`),
    CONSTRAINT `loan_customer_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE CASCADE
);

INSERT INTO `loans` (`customer_id`, `start_dt`, `loan_type`, `total_loan`, `amount_paid`, `outstanding_amount`,
                     `create_dt`)
VALUES (1, '2020-10-13', 'Home', 200000, 50000, 150000, '2020-10-13');

INSERT INTO `loans` (`customer_id`, `start_dt`, `loan_type`, `total_loan`, `amount_paid`, `outstanding_amount`,
                     `create_dt`)
VALUES (1, '2020-06-06', 'Vehicle', 40000, 10000, 30000, '2020-06-06');

INSERT INTO `loans` (`customer_id`, `start_dt`, `loan_type`, `total_loan`, `amount_paid`, `outstanding_amount`,
                     `create_dt`)
VALUES (1, '2018-02-14', 'Home', 50000, 10000, 40000, '2018-02-14');

INSERT INTO `loans` (`customer_id`, `start_dt`, `loan_type`, `total_loan`, `amount_paid`, `outstanding_amount`,
                     `create_dt`)
VALUES (1, '2018-02-14', 'Personal', 10000, 3500, 6500, '2018-02-14');

CREATE TABLE `cards`
(
    `card_id`          int          NOT NULL AUTO_INCREMENT,
    `card_number`      varchar(100) NOT NULL,
    `customer_id`      int          NOT NULL,
    `card_type`        varchar(100) NOT NULL,
    `total_limit`      int          NOT NULL,
    `amount_used`      int          NOT NULL,
    `available_amount` int          NOT NULL,
    `create_dt`        date DEFAULT NULL,
    PRIMARY KEY (`card_id`),
    KEY `customer_id` (`customer_id`),
    CONSTRAINT `card_customer_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE CASCADE
);

INSERT INTO `cards` (`card_number`, `customer_id`, `card_type`, `total_limit`, `amount_used`, `available_amount`,
                     `create_dt`)
VALUES ('4565XXXX4656', 1, 'Credit', 10000, 500, 9500, CURDATE());

INSERT INTO `cards` (`card_number`, `customer_id`, `card_type`, `total_limit`, `amount_used`, `available_amount`,
                     `create_dt`)
VALUES ('3455XXXX8673', 1, 'Credit', 7500, 600, 6900, CURDATE());

INSERT INTO `cards` (`card_number`, `customer_id`, `card_type`, `total_limit`, `amount_used`, `available_amount`,
                     `create_dt`)
VALUES ('2359XXXX9346', 1, 'Credit', 20000, 4000, 16000, CURDATE());

CREATE TABLE `notice_details`
(
    `notice_id`      int          NOT NULL AUTO_INCREMENT,
    `notice_summary` varchar(200) NOT NULL,
    `notice_details` varchar(500) NOT NULL,
    `notic_beg_dt`   date         NOT NULL,
    `notic_end_dt`   date DEFAULT NULL,
    `create_dt`      date DEFAULT NULL,
    `update_dt`      date DEFAULT NULL,
    PRIMARY KEY (`notice_id`)
);

INSERT INTO `notice_details` (`notice_summary`, `notice_details`, `notic_beg_dt`, `notic_end_dt`, `create_dt`,
                              `update_dt`)
VALUES ('Home Loan Interest rates reduced',
        'Home loan interest rates are reduced as per the goverment guidelines. The updated rates will be effective immediately',
        CURDATE() - INTERVAL 30 DAY, CURDATE() + INTERVAL 30 DAY, CURDATE(), null);

INSERT INTO `notice_details` (`notice_summary`, `notice_details`, `notic_beg_dt`, `notic_end_dt`, `create_dt`,
                              `update_dt`)
VALUES ('Net Banking Offers',
        'Customers who will opt for Internet banking while opening a saving account will get a $50 amazon voucher',
        CURDATE() - INTERVAL 30 DAY, CURDATE() + INTERVAL 30 DAY, CURDATE(), null);

INSERT INTO `notice_details` (`notice_summary`, `notice_details`, `notic_beg_dt`, `notic_end_dt`, `create_dt`,
                              `update_dt`)
VALUES ('Mobile App Downtime',
        'The mobile application of the EazyBank will be down from 2AM-5AM on 12/05/2020 due to maintenance activities',
        CURDATE() - INTERVAL 30 DAY, CURDATE() + INTERVAL 30 DAY, CURDATE(), null);

INSERT INTO `notice_details` (`notice_summary`, `notice_details`, `notic_beg_dt`, `notic_end_dt`, `create_dt`,
                              `update_dt`)
VALUES ('E Auction notice',
        'There will be a e-auction on 12/08/2020 on the Bank website for all the stubborn arrears.Interested parties can participate in the e-auction',
        CURDATE() - INTERVAL 30 DAY, CURDATE() + INTERVAL 30 DAY, CURDATE(), null);

INSERT INTO `notice_details` (`notice_summary`, `notice_details`, `notic_beg_dt`, `notic_end_dt`, `create_dt`,
                              `update_dt`)
VALUES ('Launch of Millennia Cards',
        'Millennia Credit Cards are launched for the premium customers of EazyBank. With these cards, you will get 5% cashback for each purchase',
        CURDATE() - INTERVAL 30 DAY, CURDATE() + INTERVAL 30 DAY, CURDATE(), null);

INSERT INTO `notice_details` (`notice_summary`, `notice_details`, `notic_beg_dt`, `notic_end_dt`, `create_dt`,
                              `update_dt`)
VALUES ('COVID-19 Insurance',
        'EazyBank launched an insurance policy which will cover COVID-19 expenses. Please reach out to the branch for more details',
        CURDATE() - INTERVAL 30 DAY, CURDATE() + INTERVAL 30 DAY, CURDATE(), null);

CREATE TABLE `contact_messages`
(
    `contact_id`    varchar(50)   NOT NULL,
    `contact_name`  varchar(50)   NOT NULL,
    `contact_email` varchar(100)  NOT NULL,
    `subject`       varchar(500)  NOT NULL,
    `message`       varchar(2000) NOT NULL,
    `create_dt`     date DEFAULT NULL,
    PRIMARY KEY (`contact_id`)
);

CREATE TABLE `authorities`
(
    `id`          int         NOT NULL AUTO_INCREMENT,
    `customer_id` int         NOT NULL,
    `name`        varchar(50) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `customer_id` (`customer_id`),
    CONSTRAINT `authorities_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`)
);

INSERT INTO `authorities` (`customer_id`, `name`)
VALUES (1, 'VIEWACCOUNT');

INSERT INTO `authorities` (`customer_id`, `name`)
VALUES (1, 'VIEWCARDS');

INSERT INTO `authorities` (`customer_id`, `name`)
VALUES (1, 'VIEWLOANS');

INSERT INTO `authorities` (`customer_id`, `name`)
VALUES (1, 'VIEWBALANCE');

DELETE FROM authorities;

INSERT INTO `authorities` (`customer_id`, `name`)
VALUES (1, 'ROLE_USER');

INSERT INTO `authorities` (`customer_id`, `name`)
VALUES (1, 'ROLE_ADMIN');

# CREATE TABLE users
# (
#     id       INT         NOT NULL AUTO_INCREMENT,
#     username VARCHAR(45) NOT NULL,
#     password VARCHAR(45) NOT NULL,
#     enabled  INT         NOT NULL,
#     PRIMARY KEY (id)
# );
#
# CREATE TABLE authorities
# (
#     id        INT         NOT NULL AUTO_INCREMENT,
#     username  VARCHAR(45) NOT NULL,
#     authority VARCHAR(45) NOT NULL,
#     PRIMARY KEY (ID)
# );
#
# INSERT
#     IGNORE
# INTO users
# VALUES (NULL, 'happy', '12345', '1');
# INSERT
#     IGNORE
# INTO authorities
# VALUES (NULL, 'happy', 'write');
#
#
# CREATE TABLE customer
# (
#     id    INT          NOT NULL AUTO_INCREMENT,
#     email VARCHAR(45)  NOT NULL UNIQUE,
#     pwd   VARCHAR(200) NOT NULL,
#     role  VARCHAR(45)  NOT NULL,
#     PRIMARY KEY (id)
# );
#
# INSERT INTO customer (email, pwd, role)
# VALUES ('johndoe@yopmail.com', '54321', 'admin');