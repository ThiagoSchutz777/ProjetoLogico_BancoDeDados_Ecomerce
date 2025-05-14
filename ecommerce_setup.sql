-- Criação do banco de dados para o cenário de E-commerce
create database ecommerce;
use ecommerce;

SET foreign_key_checks = 0;
-- =========================
-- CRIAÇÃO DAS TABELAS BASE
-- =========================

-- criar tabela pagamento
create table methodsPayments(
	id_methods_Payments int not null auto_increment primary key,
    NumberCard char(16) not null,
    CardExpirationDate date not null,
    NameCard varchar(45) not null
);
alter table methodsPayments 
add constraint unique_card_details unique (NumberCard, CardExpirationDate, NameCard);


-- criar tabela clientePf
create table client_pf(
	id_Client_pf int auto_increment not null primary key,
    Fname varchar(45) not null,
    Minit char(3),
    Adress varchar(45) not null,
    Bdate date not null,
    CPF char(11) not null,
    contact char(11) not null,
    constraint unique_cpf_client unique(CPF)
);

-- criar tabela clientePj
create table client_pj(
	id_Client_pj int auto_increment not null primary key,
    contact char(11) not null,
	SocialName varchar(45) not null,
    constraint unique_social_clientepj unique(SocialName),
    CNPJ char(14) not null,
    constraint unique_CNPJ unique(CNPJ),
    Adress varchar(45) not null
);

-- criar tabela Estoque
create table storageLocation(
	idStorage int not null auto_increment primary key,
    LocationStorage varchar(45)
);

-- criar tabela produto
create table product(
	idProduct int auto_increment not null primary key,
    ValueProduct decimal(10, 2) not null,
    Category enum('Eletrônicos','Alimentos','Móveis','Brinquedos') not null,
    Pname varchar(50) not null,
    Classification_kids bool,
    avaliação float default 0
);

-- tabela pedido
create table orders(
	idOrders int not null auto_increment primary key,
    id_Client_pf int,
    id_Client_pj int,
    OrdersStats ENUM('Em Andamento', 'Processando', 'Enviado', 'Entregue') not null default'Processando',
    OrdersDescription varchar(45),
    OrdersFreight decimal(10, 2) default 10
);
alter table orders
add constraint fk_orders_clientpf
foreign key(id_Client_pf) references Client_pf(id_Client_pf),
add constraint fk_orders_clientpj 
foreign key(id_Client_pj) references client_pj(id_Client_pj);

-- criar tabela de transações
create table orders_transactions(
	idOrderTransactions int not null auto_increment primary key,
    idOrders int not null,
    id_methods_Payments int,
	amount decimal(10, 2) not null, 
    transaction_date datetime not null,
	transaction_status enum('Aprovado', 'Recusado', 'Pendente', 'Reembolsado') not null
);
alter table orders_transactions
add constraint fk_order_transactions_orders
foreign key (idOrders) references orders(idOrders),
add constraint fk_order_transactions_payment_method
foreign key (id_methods_Payments) references methodsPayments(id_methods_Payments);

-- criar tabela Vendedor(Terceiro)
create table Seller(
	idSeller int not null auto_increment primary key,
    socialName varchar(45) not null,
	constraint unique_socialName_Seller unique(SocialName),
    CNPJ char(14),
    constraint unique_CNPJ_Seller unique(CNPJ),
    Adress varchar(45) not null,
    contact char(11) not null
);

-- criar tabelas fornecedor
create table supplier(
	idSupplier int not null auto_increment primary key,
    socialName varchar(45) not null,
    constraint unique_socialName_supplier unique(socialName),
    CNPJ char(14),
    constraint unique_CNPJ_supplier unique(CNPJ),
    contact char(11) not null,
    Adress varchar(45)
);

-- criar tabela entrega do pedido
create table delivery(
	idDelivery int not null auto_increment primary key,
    idOrders int not null,
    trackingCode varchar(45) not null,
    constraint unique_tracking_code unique(trackingCode),
    orderStatus enum('Processando pagamento','Enviado','Em Rota de Entrega','Entregue') default'Processando pagamento'
);
alter table delivery
add constraint fk_delivery_orders
foreign key (idOrders) references orders(idOrders); 

-- =================================
-- TABELAS DE RELACIONAMENTO
-- =================================

-- Relação n * m cliente e pagamento
create table methods_payment_Client_pf(
	id_Client_pf  int,
    id_methods_Payments int,
    primary key(id_Client_pf , id_methods_Payments)
);
alter table methods_payment_Client_pf
add constraint fk_paymentClient_client 
foreign key(id_Client_pf ) references client_pf(id_Client_pf ),
add constraint fk_methods_paymentClient_pf
foreign key(id_methods_Payments) references methodsPayments(id_methods_Payments);

-- Relação n * m cliente pj e pagamento
create table methods_payment_Client_pj(
	id_Client_pj int,
    id_methods_Payments int,
    primary key(id_Client_pj, id_methods_Payments)
);
alter table methods_payment_Client_pj
add constraint fk_paymentClient_pj
foreign key(id_Client_pj) references client_pj(id_Client_pj),
add constraint fk_paymentClientpj_payment 
foreign key(id_methods_Payments) references methodsPayments(id_methods_Payments);

-- criar tabela (n * m) estoque e produto
create table storageProducts(
	 idProduct int,
     idStorage int,
     QuantityProducts int not null,
     location varchar(255) not null,
     primary key (idProduct, idStorage)
);
alter table storageProducts
add constraint fk_storageProducts_product 
foreign key (idProduct) references product(idProduct),
add constraint fk_storageProducts_storageLocation
foreign key (idStorage) references storageLocation(idStorage);

-- criar tabela (n * m) produto e pedido
create table productsOrders(
	idProduct int,
    idOrders int,
    QuantityProducts int default 1,
    unitPrice decimal(10,2),
    primary key(idProduct, idOrders)
);
alter table productsOrders
add constraint fk_productsOrders_product 
foreign key(idProduct) references product(idProduct),
add constraint fk_productsOrders_Orders 
foreign key(idOrders) references Orders(idOrders);

-- criar tabela (n * m) fornecedor e produto
create table supplierProducts(
	idProduct int,
    idSupplier int,
    primary key(idProduct,idSupplier)
);
alter table supplierProducts
add constraint fk_supplierProducts_product 
foreign key(idProduct) references product(idProduct),
add  constraint fk_SupplierProducts_supplier 
foreign key(idSupplier) references supplier(idSupplier);

-- criar tabela (n * m) produto e vendedor(terceiro)
create table SellerProducts(
	idSeller int,
    idProduct int,
    primary key(idSeller, idProduct)
);
alter table SellerProducts
add constraint fk_sellerProducts_seller 
foreign key(idSeller) references Seller(idSeller),
add constraint fk_sellerProducts_product 
foreign key(idProduct) references product(idProduct);


-- INSERÇÃO DE DADOS (TESTES)
-- ====================================

INSERT INTO client_pf (Fname, Minit, Adress, Bdate, CPF, contact) VALUES
('Ronaldo', 'T', 'Rua E, 10', '2006-03-03', '12345678901', '51992030800'),
('Ana', 'C', 'Av. B, 25', '1990-07-15', '98765432109', '11987654321'),
('Pedro', 'L', 'Rua F, 300', '1985-11-20', '11223344556', '21998765432'),
('Sofia', 'M', 'Travessa G, 5', '2000-01-01', '55667788990', '31996543210'),
('Lucas', 'R', 'Alameda H, 120', '1995-04-28', '22334455667', '41995432109'),
('Fernanda', 'P', 'Rua I, 50', '1992-09-10', '77889900112', '51991122334'),
('Rafael', 'S', 'Av. J, 150', '1988-02-25', '33445566778', '11980099887'),
('Patricia', 'A', 'Rua K, 75', '1998-06-18', '44556677889', '21997788990');

INSERT INTO client_pj (SocialName, contact, CNPJ, Adress) VALUES
('Tech Solutions Ltda', '11999990000', '12345678000199', 'Rua das Inovações, 101'),
('Agro Brasil S.A.', '11988887777', '98765432000188', 'Av. Campo Verde, 200'),
('Construtora Alpha', '11977776666', '11223344000155', 'Rua das Obras, 300'),
('Logística Rápida Express', '11966665555', '55667788000122', 'Av. das Entregas, 400'),
('Serviços Integrados Pro', '11955554444', '33445566000133', 'Rua Central, 500');

INSERT INTO methodsPayments (NumberCard, CardExpirationDate, NameCard) VALUES
('4111111111111111', '2027-05-01', 'CARLOS SILVA'),
('5500000000000002', '2026-11-30', 'ANA SOUZA'),
('3400000000000093', '2028-03-15', 'JOAO MENDES'),
('3000000000000044', '2029-07-22', 'MARIANA LIMA'),
('6011000000000005', '2025-12-10', 'LUCAS ROCHA'),
('4111111111111106', '2028-08-20', 'FERNANDA OLIVEIRA'),
('5500000000000007', '2027-04-18', 'RAFAEL COSTA'),
('3400000000000088', '2029-01-25', 'PATRICIA PEREIRA'),
('3000000000000099', '2026-06-12', 'ANDRE ALMEIDA'),
('6011000000000010', '2030-02-14', 'GABRIELA SANTOS');

INSERT INTO storageLocation (LocationStorage) VALUES
('Centro de Distribuição SP'),
('Armazém RJ'),
('Depósito MG'),
('Galpão Curitiba'),
('Estoque Recife');

INSERT INTO product (ValueProduct, Category, Pname, Classification_kids, avaliação) VALUES
(2500.00, 'Eletrônicos', 'SmartTV 50', false, 4.5),
(50.50, 'Alimentos', 'Cereal Matinal', true, 4.0),
(1200.00, 'Móveis', 'Sofá 3 Lugares', false, 4.8),
(150.00, 'Brinquedos', 'Lego Castelo', true, 5.0),
(400.75, 'Eletrônicos', 'Headset Gamer', false, 4.2),
(75.00, 'Alimentos', 'Barras de Cereal (Cx c/10)', false, 4.1),
(350.00, 'Móveis', 'Mesa de Centro', false, 4.6),
(80.00, 'Brinquedos', 'Boneca Articulada', true, 4.7);

INSERT INTO Seller (socialName, CNPJ, Adress, contact) VALUES
('TechDistribuidora', '12345678000101', 'Rua das Inovações, 100', '11987654321'),
('GamesExpress ME', '23456789000102', 'Avenida Gamer, 200', '11981234567'),
('MoveisEstilo SA', '34567890000103', 'Rua do Design, 300', '11985678901'),
('EletronicParts Brasil', '45678901000104', 'Av. Tecnologia, 400', '11983456789'),
('Alimentos do Sul Ltda', '56789012000105', 'Rua da Fazenda, 500', '11982345678');

INSERT INTO supplier (socialName, CNPJ, contact, Adress) VALUES
('FornecedoraTech Ltda', '11222333000101', '11991234567', 'Rua dos Eletrônicos, 123'),
('Alfa Distribuições', '22334455000102', '11992345678', 'Avenida Central, 456'),
('NaturalFoods Brasil', '33445566000103', '11993456789', 'Rua dos Orgânicos, 789'),
('EstoqueMóveis SA', '44556677000104', '11994567890', 'Travessa dos Móveis, 321'),
('Suprimentos Global', '55667788000105', '11995678901', 'Alameda Comércio, 654');

-- =================================================
-- INSERÇÃO DE DADOS (TESTES) TABELAS RELACIONAMENTO
-- =================================================
INSERT INTO methods_payment_Client_pf (id_Client_pf, id_methods_Payments) VALUES
(1, 1), -- Ronaldo (PF 1) usa o cartão 1
(1, 2), -- Ronaldo (PF 1) também usa o cartão 2
(2, 3), -- Ana (PF 2) usa o cartão 3
(3, 4), -- Pedro (PF 3) usa o cartão 4
(4, 5), -- Sofia (PF 4) usa o cartão 5
(5, 1), -- Lucas (PF 5) usa o cartão 1
(6, 6), -- Fernanda (PF 6) usa o cartão 6
(7, 7); -- Rafael (PF 7) usa o cartão 7

INSERT INTO methods_payment_Client_pj (id_Client_pj, id_methods_Payments) VALUES
(1, 8), -- Tech Solutions (PJ 1) usa cartão 8
(1, 9), -- Tech Solutions (PJ 1) usa cartão 9
(2, 10), -- Agro Brasil (PJ 2) usa cartão 10
(3, 1), -- Construtora Alpha (PJ 3) usa cartão 1 (compartilhado com PFs)
(4, 2); -- Logística Rápida (PJ 4) usa cartão 2 (compartilhado com PFs)

INSERT INTO orders (id_Client_pf, id_Client_pj, OrdersStats, OrdersDescription, OrdersFreight) VALUES
(1, NULL, 'Processando', 'Compra de eletrônicos e alimentos', 25.00), -- Pedido do PF 1 (Ronaldo)
(NULL, 1, 'Em Andamento', 'Pedido de equipamentos e móveis', 40.00), -- Pedido do PJ 1 (Tech Solutions)
(2, NULL, 'Enviado', 'Compra de brinquedos', 15.50), -- Pedido do PF 2 (Ana)
(1, NULL, 'Entregue', 'Móveis para escritório', 45.00), -- Pedido do PF 1 (Ronaldo) novamente
(3, NULL, 'Processando', 'Pedido de eletrônicos', 20.00), -- Pedido do PF 3 (Pedro)
(NULL, 2, 'Processando', 'Suprimentos de TI', 30.00), -- Pedido do PJ 2 (Agro Brasil)
(4, NULL, 'Em Andamento', 'Compra de alimentos', 10.00); -- Pedido do PF 4 (Sofia)

INSERT INTO storageProducts (idProduct, idStorage, QuantityProducts, location) VALUES
(1, 1, 150, 'Corredor A, Prateleira 1'), -- SmartTV no CD SP
(2, 1, 75, 'Corredor A, Prateleira 2'), -- Cereal Matinal no CD SP
(3, 2, 50, 'Armazém RJ, Setor Móveis Grandes'), -- Sofá no Armazém RJ
(4, 3, 200, 'Depósito MG, Área Brinquedos'), -- Lego no Depósito MG
(5, 4, 30, 'Galpão Curitiba, Eletrônicos'), -- Headset no Galpão Curitiba
(1, 5, 10, 'Estoque Recife, Showroom'), -- SmartTV também no Estoque Recife (quantidade menor)
(6, 1, 100, 'Corredor B, Alimentos Secos'), -- Barras de Cereal no CD SP
(7, 2, 20, 'Armazém RJ, Setor Móveis Pequenos'), -- Mesa de Centro no Armazém RJ
(8, 3, 80, 'Depósito MG, Área Brinquedos 2'); -- Boneca no Depósito MG

INSERT INTO productsOrders (idProduct, idOrders, QuantityProducts, unitPrice) VALUES
(1, 1, 1, 2500.00), -- 1 SmartTV no Pedido 1 (Preço original)
(2, 1, 2, 50.50),   -- 2 Cereal Matinal no Pedido 1 (Preço original)
(3, 2, 1, 1200.00), -- 1 Sofá 3 Lugares no Pedido 2
(7, 2, 1, 350.00),  -- 1 Mesa de Centro no Pedido 2
(4, 3, 3, 150.00),  -- 3 Lego Castelo no Pedido 3
(3, 4, 1, 1150.00), -- 1 Sofá 3 Lugares no Pedido 4 (Preço promocional!)
(5, 5, 2, 400.75),  -- 2 Headset Gamer no Pedido 5
(1, 5, 1, 2400.00), -- 1 SmartTV no Pedido 5 (Outro preço!)
(5, 6, 5, 390.00),  -- 5 Headset Gamer no Pedido 6 (Preço para PJ)
(2, 7, 5, 50.00),   -- 5 Cereal Matinal no Pedido 7 (Preço promocional!)
(6, 7, 2, 70.00);   -- 2 Barras de Cereal no Pedido 7 (Preço promocional!)

INSERT INTO supplierProducts (idProduct, idSupplier) VALUES
(1, 1), -- SmartTV da FornecedoraTech
(1, 2), -- SmartTV também da Alfa Distribuições
(2, 3), -- Cereal Matinal da NaturalFoods
(6, 3), -- Barras de Cereal da NaturalFoods
(3, 4), -- Sofá da EstoqueMóveis
(7, 4), -- Mesa de Centro da EstoqueMóveis
(4, 2), -- Lego da Alfa Distribuições
(8, 2), -- Boneca da Alfa Distribuições
(5, 1), -- Headset da FornecedoraTech
(5, 5); -- Headset também da Suprimentos Global

INSERT INTO SellerProducts (idSeller, idProduct) VALUES
(1, 1), -- Vendedor 1 vende SmartTV
(1, 5), -- Vendedor 1 vende Headset
(2, 4), -- Vendedor 2 vende Lego
(2, 8), -- Vendedor 2 vende Boneca
(3, 3), -- Vendedor 3 vende Sofá
(3, 7), -- Vendedor 3 vende Mesa de Centro
(4, 1), -- Vendedor 4 vende SmartTV
(4, 5), -- Vendedor 4 vende Headset
(5, 2), -- Vendedor 5 vende Cereal Matinal
(5, 6); -- Vendedor 5 vende Barras de Cereal

INSERT INTO delivery (idOrders, trackingCode, orderStatus) VALUES
(1, 'TRK123456789BR', 'Enviado'), -- Entrega para Pedido 1
(2, 'TRK234567890BR', 'Em Rota de Entrega'), -- Entrega para Pedido 2
(3, 'TRK345678901BR', 'Entregue'), -- Entrega para Pedido 3
(4, 'TRK456789012BR', 'Processando pagamento'), -- Entrega para Pedido 4 (status da entrega)
(5, 'TRK567890123BR', 'Enviado'), -- Entrega para Pedido 5
(1, 'TRK123456799BR', 'Enviado'); -- Segunda entrega para o Pedido 1 (ex: pacote separado)

INSERT INTO orders_transactions (idOrders, id_methods_Payments, amount, transaction_date, transaction_status) VALUES
(1, 1, 2601.00, '2025-05-13 10:00:00', 'Aprovado'), -- Pedido 1 pago com Método 1 (Valor: 1*2500 + 2*50.50 + 25 frete = 2601)
(2, 3, 1590.00, '2025-05-13 10:05:00', 'Aprovado'), -- Pedido 2 pago com Método 3 (Valor: 1*1200 + 1*350 + 40 frete = 1590)
(3, 4, 450.00,  '2025-05-13 10:10:00', 'Recusado'), -- Pedido 3, tentativa falha com Método 4 (Valor: 3*150 + 15.5 frete = 465.5)
(3, 4, 465.50,  '2025-05-13 10:15:00', 'Aprovado'), -- Pedido 3, segunda tentativa com Método 4 (Valor correto)
(4, 5, 1195.00, '2025-05-13 10:20:00', 'Aprovado'), -- Pedido 4 pago com Método 5 (Valor: 1*1150 + 45 frete = 1195)
(5, 1, 2820.75, '2025-05-13 10:25:00', 'Aprovado'), -- Pedido 5 pago com Método 1 (Valor: 2*400.75 + 1*2400 + 20 frete = 2820.75)
(6, 6, 1980.00, '2025-05-13 10:30:00', 'Aprovado'), -- Pedido 6 pago com Método 6 (Valor: 5*390 + 30 frete = 1980)
(7, 8, 610.00, '2025-05-13 10:35:00', 'Aprovado'), -- Pedido 7 pago com Método 8 (Valor: 5*50 + 2*70 + 10 frete = 250 + 140 + 10 = 400) -- RECALCULANDO VALOR AQUI - VALOR CORRETO = 400
(7, 8, 400.00, '2025-05-13 10:35:00', 'Aprovado'), -- Pedido 7 pago com Método 8 (Valor: 5*50 + 2*70 + 10 frete = 400) -- Correção
(5, NULL, 50.00, '2025-05-13 10:40:00', 'Reembolsado'); -- Simula um reembolso parcial no Pedido 5 (sem referência a um método específico)

SET foreign_key_checks = 1;