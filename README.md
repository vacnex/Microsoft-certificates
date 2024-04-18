# Cách 1
## BIOS

Chú ý :
- db.auth là Authorized Signatures
- kek.auth là KEK (Key Exchange Keys)
- pk.auth là PK (Platform key).

Vào BIOS và tìm đến phần Secure Boot. ( Có thể ở mục lớn Secure Boot hoặc Boot )

Trong phần Secure Boot, thường có các tùy chọn như là restore default factory keys, Key Management. Ví dụ trên Mainboard Z390 Aorus Elite, menu này nằm trong Boot >> Tab Secure Boot >> Key Management. Nếu có phần này thì chúng ta có thể chỉnh sửa được key Secure Boot ngay tại BIOS.

![image](https://github.com/hoaug-tran/Microsoft-certificates/assets/92006941/548351fd-6e68-4fc5-95f1-bede6023ffd9)

Đầu tiên chọn bấm restore default factory keys để restore lại key mặc định. Tiếp theo bấm vào Restore Factory keys >> Install factory defaults >> bấm Yes .

![image](https://github.com/hoaug-tran/Microsoft-certificates/assets/92006941/7c010048-d38c-4fe4-8539-6d9e187c26f8)


Bây giờ các bác có thể chỉnh sửa key Secure Boot. Tiếp theo chọn vào Authorized Signatures >> Key Exchange Keys >> Platform Key (PK). Tiếp đó chọn vào update (tức là thay thế), thêm nó vào những key hiện có hoặc xoá nó ( tốt nhất là xoá nó ). Ví dụ, với Authorized Signatures, Menu lựa chọn có: Details / Export / Update / Append / Delete. ( chúng ta nên bấm Delete rồi bấm Update để add key )

![image](https://github.com/hoaug-tran/Microsoft-certificates/assets/92006941/e73f06c0-2e0a-4a85-9e34-3cbd95bd9f63)


Chúng ta sẽ cần thay đổi 3 Key là Authorized Signatures, Key Exchange Keys và Platform key. Chúng ta sẽ làm lần lượt từng Key 1. Ví dụ đầu tiên chúng ta bấm vào Authorized Signatures và chọn vào Delete. Tiếp theo, chọn vào Update >> search in the USB device ( chọn vào cái USB ) >> cuối cùng là chọn vào file db.auth.

Làm tương tự với các mấy key còn lại. Authorized Signatures thì chọn db.auth. Exchange Keys thì chọn kek.auth. Platform key thì chọn pk.auth. Nếu cái Platform key chọn xong mà bị Secure Violation hay gì tương tự nó chúng ta quay trở lại Restore default factory keys. Restore xong thì làm lại với Authorized Signatures và Exchange Keys thôi. Còn cái Platform key chúng ta sẽ bỏ không thay thế ( tức là để nó mặc định ).

Các BIOS khác cũng làm tương tự.

![image](https://github.com/hoaug-tran/Microsoft-certificates/assets/92006941/470ef618-665d-4621-8d74-7a6e7992db52)



# CÁCH 2:
## Sử dụng KeyTool

Tải KeyTool.efi tại đây: [bootx64.zip](https://github.com/hoaug-tran/Microsoft-certificates/files/15018456/bootx64.zip)

Tiếp theo Format USB với định dạng là FAT32 và MBR. Tiếp đó, bên trong USB tạo thư mục tên "EFI". Tiếp nữa, vào thư mục EFI và tạo thêm thư mục tên "BOOT". Cuối cùng Copy KeyTool.efi ( bootx64.efi ) vào trong thư mục BOOT.

Vẫn cắm USB. khởi động lại máy và vào MenuBoot của bios rồi chọn Boot vào USB.


![image](https://github.com/hoaug-tran/Microsoft-certificates/assets/92006941/2f141950-4b9b-4a97-a5a9-9dbca45a667a)


Cũng tương tự như Cách 1. Chú ý tới Allowed Signature Database ( tức file db.auth ),  Key Exchange Keys Database ( tức file kek.auth ) và Platform Key ( tức file pk.auth ). Ví dụ, chọn vào Allowed Signature Database (db) >> Replace Keys >> USB device ( Chọn No ) >> chọn db.auth trong USB >> Enter >> Quay trở lại.

![image](https://github.com/hoaug-tran/Microsoft-certificates/assets/92006941/447a841f-c9b1-4caf-b210-9826a07bfdda)


![image](https://github.com/hoaug-tran/Microsoft-certificates/assets/92006941/1e18ff67-c30f-4ea8-95a7-2bb8361364dd)


![image](https://github.com/hoaug-tran/Microsoft-certificates/assets/92006941/5088be12-b664-4c41-ae47-465ce046bb9c)

Cứ Làm tương tự với các mấy key còn lại. Authorized Signatures thì chọn db.auth. Exchange Keys thì chọn kek.auth. Platform key thì chọn pk.auth. Nếu cái Platform key chọn xong mà bị Secure Violation hay gì tương tự nó chúng ta quay trở lại Restore default factory keys. Restore xong thì làm lại với Authorized Signatures và Exchange Keys thôi. Còn cái Platform key chúng ta sẽ bỏ không thay thế ( tức là để nó mặc định ).
