show databases;
use ecommerce;
show tables;

-- Quantos pedidos foram feitos por cada cliente?
select c.Fname as NomeCliente, 'PF' as TipoCliente, COUNT(o.idOrders) as TotalPedidos
from client_pf c
join orders o on c.id_client_pf = o.id_client_pf
group by c.id_client_pf, NomeCliente

union all

select c.socialName as NomeCliente, 'Pj' as TipoCliente, COUNT(o.idOrders) as TotalPedidos
from client_pj c
join orders o on c.id_client_pj = o.id_client_pj
group by c.id_client_pj, NomeCliente
order by TipoCliente, NomeCliente;

-- Algum vendedor também é fornecedor?	
select s.socialName as nomeVendedor,s.CNPJ as CNPJvendedor, sup.socialName as nomeFornecedor, sup.CNPJ as CNPJfornecedor,
'<->' as relaçao
from seller s 
inner join supplier sup on s.CNPJ = sup.CNPJ
where s.CNPJ is not null and sup.CNPJ is not null;

-- Relação de produtos fornecedores e estoques; 
select p.Pname as nomeProduto, p.Category as Categoria, sl.LocationStorage as LocalEstoque, sp.QuantityProducts as QuantidadeEmEstoque, s.socialName as NomeFornecedor,
'<->' as relaçao
from product p
left join storageProducts sp on p.idProduct = sp.idProduct
left join storageLocation sl on sp.idStorage = sl.idStorage
left join supplierProducts sup on p.idProduct = sup.idProduct
left join supplier s on sup.idSupplier = s.idSupplier
order by p.Pname, LocalEstoque, NomeFornecedor; 

-- Relação de nomes dos fornecedores e nomes dos produtos;
select p.Pname as nomeProduto, s.socialName as NomeFornecedor,
'<->' as relaçao
from supplier s
inner join supplierProducts sp on s.idSupplier = sp.idSupplier
inner join product p on p.idProduct = sp.idProduct;

-- Crie expressões para gerar atributos derivados
SELECT po.idOrders, po.idProduct, (po.QuantityProducts * po.unitPrice) AS SubtotalItem FROM productsOrders po;
