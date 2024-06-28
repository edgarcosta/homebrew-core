class FfPoly < Formula
  desc "fast finite field arithmetic over word size prime fields (up to 61 bits)"
  homepage "http://math.mit.edu/~drew/"
  # tag "math"
  url "https://math.mit.edu/~drew/ff_poly_v1.3.0.tar"
  sha256 "d2c8b3c2536407f13c54450783af5e4d432b0f073638db7f9db85b21ef775b7f"


  depends_on "gmp"

  patch :DATA

  def install
    system "make"
    system "make", "install", "INSTALL_ROOT=#{prefix}"
  end


end
__END__
diff --git a/makefile b/makefile
index b058da1..36ab4aa 100644
--- a/makefile
+++ b/makefile
@@ -1,9 +1,9 @@
-CC = gcc
+# CC = gcc
 CFLAGS = -O3 -fomit-frame-pointer -funroll-loops -m64 -pedantic -std=gnu99
-LDFLAGS = -static
-INCLUDES = -I/usr/local/include
+LDFLAGS = # -static
+INCLUDES = # -I/usr/local/include
 LIBS = -lgmp -lm
-INSTALL_ROOT = /usr/local
+# INSTALL_ROOT = /usr/local
 
 HEADERS = asm.h ff.h ffmontgomery64.h ff2k.h ffext.h ffpolyfromroots.h ffpolybig.h ffpolysmall.h ffpoly.h cstd.h ntutil.h polyparse.h
 OBJECTS = ff.o ff2k.o  ffext.o  ffpolyfromroots.o ffpolysmall.o ffpoly_small.o polyparse.o
@@ -15,9 +15,10 @@ clean:
 	rm -f libff_poly.a
 	
 install: all
-	cp -v ff_poly.h $(INSTALL_ROOT)/include
 	mkdir -p $(INSTALL_ROOT)/include/ff_poly
+	cp -v ff_poly.h $(INSTALL_ROOT)/include
 	cp -v $(HEADERS) $(INSTALL_ROOT)/include/ff_poly
+	mkdir -p $(INSTALL_ROOT)/lib
 	cp -v libff_poly.a $(INSTALL_ROOT)/lib
 	
 ##### ff_poly library (standard version only supports small polys (degree < 256) and does not depend on zn_poly)


