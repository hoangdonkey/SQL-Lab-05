USE master
GO

IF EXISTS(SELECT * FROM sys.databases WHERE NAME = 'test')
	DROP DATABASE test
GO

CREATE DATABASE test
GO
USE test
GO

CREATE TABLE PhongBan
(	MaPB VARCHAR(7),
	TenPB NVARCHAR(50),
	CONSTRAINT pk_mapb PRIMARY KEY (MaPB))
GO

CREATE TABLE NhanVien
(	MaNV VARCHAR(7),
	TenNV NVARCHAR(50),
	NgaySinh DATETIME,
	SoCMND CHAR(9),
	GioiTinh CHAR DEFAULT ('M'),
	DiaChi NVARCHAR	(100),
	NgayVaoLam DATETIME,
	MaPB VARCHAR(7),
	CONSTRAINT pk_manv PRIMARY KEY (MaNV),
	CONSTRAINT chk_ngaysinh CHECK (NgaySinh < GETDATE()),
	CONSTRAINT chk_soCMND CHECK (ISNUMERIC (SoCMND) = 1),
	CONSTRAINT chk_gioitinh CHECK (GioiTinh = 'M' OR GioiTinh = 'F'),
	CONSTRAINT chk_datein CHECK (DATEDIFF(YEAR,NgaySinh,NgayVaoLam) >= 20),
	CONSTRAINT fk_mapb FOREIGN KEY (MaPB) REFERENCES PhongBan(MaPB)
)

CREATE TABLE LuongDA (
	MaDA varchar(8),
	MaNV varchar(7),
	NgayNhan datetime NOT NULL default(getdate()),
	SoTien money,
	CONSTRAINT pk_DANV PRIMARY KEY (MaDA,MaNV),
	CONSTRAINT fk_manv FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
	CONSTRAINT chk_luongDA CHECK (SoTien > 0)
)

INSERT INTO PhongBan VALUES
	('00000A1','Phong A'),
	('00000A2','Phong B'),
	('00000A3','Phong C'),
	('00000A4','Phong D'),
	('00000A5','Phong E')
GO

INSERT INTO NhanVien VALUES
	('000000A','Nguyen Van A','11/01/1990','000000001','M','Ha Noi','09/10/2020','00000A1'),
	('000000B','Nguyen Van B','11/02/1991','000000002','F','Ha Noi','09/11/2020','00000A2'),
	('000000C','Nguyen Van C','11/03/1992','000000003','M','Ha Noi','09/12/2020','00000A3'),
	('000000D','Nguyen Van D','11/04/1993','000000004','F','Ha Noi','09/13/2020','00000A4'),
	('000000E','Nguyen Van E','11/05/1994','000000005','M','Ha Noi','09/14/2020','00000A5')
GO

INSERT INTO LuongDA VALUES
	('00000001','000000A',getdate(),1000000),
	('00000002','000000B',getdate(),2000000),
	('00000003','000000C',getdate(),3000000),
	('00000004','000000D',getdate(),4000000),
	('00000005','000000E',getdate(),5000000)
GO

SELECT * FROM NhanVien
SELECT * FROM PhongBan
SELECT * FROM LuongDA
GO

SELECT * FROM NhanVien WHERE NhanVien.GioiTinh = 'F'
GO

SELECT LuongDA.MaDA FROM LuongDA
GO

SELECT NhanVien.MaNV,NhanVien.TenNV,SUM(LuongDA.SoTien) AS 'TongLuong' FROM NhanVien JOIN LuongDA ON LuongDA.MaNV = NhanVien.MaNV GROUP BY NhanVien.MaNV, NhanVien.TenNV
GO

SELECT * FROM NhanVien WHERE MaPB LIKE '00000A2'
GO

SELECT NhanVien.TenNV,SUM(LuongDA.SoTien) AS 'MucLuong',(SELECT TenPB FROM PhongBan WHERE MaPB LIKE '00000A3') AS 'TenPhongBan' FROM NhanVien
INNER JOIN LuongDA ON NhanVien.MaNV = LuongDA.MaNV where NhanVien.MaPB LIKE '00000A3' GROUP BY NhanVien.TenNV
GO

SELECT PhongBan.TenPB,COUNT(MaNV) AS 'So Nhan Vien' FROM NhanVien JOIN PhongBan ON PhongBan.MaPB = NhanVien.MaPB GROUP BY PhongBan.TenPB
GO

SELECT NhanVien.TenNV,LuongDA.MaDA FROM NhanVien JOIN LuongDA ON LuongDA.MaNV = NhanVien.MaNV
GO

SELECT TOP 1 TenPB FROM PhongBan ORDER BY MaPB DESC
GO

SELECT COUNT(NhanVien.MaPB) AS 'So Nhan Vien',PhongBan.TenPB FROM NhanVien JOIN PhongBan ON PhongBan.MaPB = NhanVien.MaPB WHERE NhanVien.MaPB = '1' GROUP BY PhongBan.TenPB
GO

SELECT * FROM NhanVien WHERE SoCMND LIKE '%9'
GO

SELECT TOP 1 NhanVien.TenNV,LuongDA.SoTien FROM LuongDA JOIN NhanVien ON NhanVien.MaNV = LuongDA.MaNV ORDER BY LuongDA.SoTien DESC
GO

SELECT NhanVien.TenNV FROM NhanVien WHERE MaNV IN (SELECT MaNV FROM LuongDA WHERE (SoTien > 1200000)) AND GioiTinh LIKE 'F'
GO

SELECT PhongBan.TenPB,SUM(LuongDA.SoTien) AS 'Tong Luong' FROM LuongDA JOIN NhanVien ON LuongDA.MaNV = NhanVien.MaNV JOIN PhongBan ON NhanVien.MaPB = PhongBan.MaPB WHERE LuongDA.MaNV IN (SELECT MaNV FROM NhanVien WHERE MaPB IN (SELECT MaPB FROM PhongBan)) GROUP BY PhongBan.TenPB
GO

SELECT MaDA,COUNT(MaNV) AS 'So Nhan Vien' FROM LuongDA GROUP BY MaDA HAVING (COUNT(MaNV) >= 2)
GO

SELECT * FROM NhanVien WHERE TenNV LIKE 'N%'
GO

SELECT * FROM NhanVien WHERE MaNV IN (SELECT MaNV FROM LuongDA WHERE NgayNhan >= '01/01/2003' AND NgayNhan <= '01/01/2004')
GO

SELECT * FROM NhanVien WHERE MaNV NOT IN(SELECT MaNV FROM LuongDA)
GO

DELETE FROM LuongDA WHERE MaDA='00000002'
GO

DELETE FROM LuongDA WHERE SoTien = '12000000'
GO

UPDATE LuongDA SET SoTien=SoTien*10/100 + SoTien WHERE MaDA LIKE '00000003'
GO

DELETE FROM NhanVien WHERE MaNV NOT IN (SELECT MaNV FROM LuongDA)
GO

UPDATE NhanVien SET NgayVaoLam='02/12/1999' WHERE MaPB IN (SELECT MaPB FROM PhongBan WHERE TenPB LIKE '000000A')

SELECT * FROM NhanVien
SELECT * FROM PhongBan
SELECT * FROM LuongDA
GO