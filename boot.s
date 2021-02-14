;

entry start
start:
	;stack 
	mov ax,#0x9000
	mov ss,ax
	mov si,#0x0000
	
	;diskten veri okuma
	mov ax, #0xe000  ;bellekte rasgele seçilmiş bir alan güvenli olduğu düşünülüyor
	;mov ax,#0xb800	 ;video bellek alanı başlangıcı
	mov es,ax	 ;segment olarak es seçilmeli. es:bx verinin okunacığı pointer
	seg es
	
	mov bx, #0x0000
	mov cl, #0x02
	
oku:	mov ah, #0x02	;diskten okuma
	mov al, #0x01	;her seferinde bir sektör oku
	mov dl, #0x00	;disket sürücü numarası
	mov dh, #0x00	;0. kafa
	mov ch, #0x00	;silindir nosu	
	int #0x13
	inc cl		;2 den başlayarak her seferinde bir sonraki sektörden itibaren
	add bx, #0x0200 ;bx (offset) 512 byte ileri 
	cmp bx, #0xfc00	;64000/512=125 sektör -okunacak resimdeki bitmap büyüklüğü- bitti mi?
	jne oku		;hayır


	;ekran modu değiştirme
	mov ah,#0x00     ;ekran modu değiştirme
	mov al,#0x0d	 ;320x200 16 renk vga
	;mov al,#0x13	 ;320x200 256 renk mcga/vga 
	int #0x10	 ;bios video kesmesi

	mov ah,#0x05	;sayfa seçme
	mov al,#0x00	;0. sayfa (resim renk bilgilerimizi kaydettiğimiz sayfa)
	int #0x10	;bios video kesmesi




	;okunan veriyi ekrana basma 
	;dx cx satır ve sütun numaraları
	mov bx,#0xfa00	 ;veri offset bitişi. es=0xe000 
	
d_zero: mov dx, #0x00c7	 ;199 satır sayısı
	cmp cx, #0x013f	 ;cx başlangıç değerinde mi
	jne devam 	 ;eğer başlangıç değerinde değilse kaldığı yerden devam et
c_zero:	mov cx, #0x013f	 ;319 sütun sayısı	
devam:	jcxz c_zero
	pop bx
	cmp bx, #0x0000 ;başa dönüldüyse
	je loop_e	;okumayı ve ekrana basmayı bırak
	mov al, [bx]	;renk sakladığımız alandan 
	dec bx
	push bx		;stack de sakla 
	mov ah, #0x0c	;verilen kordinata pixel yazma
	mov bh, #0x00	;sayfa numarası 0. sayfa 
	int #0x10	;kesme: 0c ile ekrana verilen koordinatta pixel basma
	dec cx
	dec dx
	cmp dx, #0x00
	je d_zero	
	jmp devam

	;sonsuz döngü
loop_e: jmp loop_e	






;	mov cx, #0xfa01	 ;64000 byte 320*200 pixel

	

