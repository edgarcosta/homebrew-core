class Flint < Formula
  desc "C library for number theory"
  homepage "http://flintlib.org"
  url "http://flintlib.org/flint-2.5.2.tar.gz"
  sha256 "cbf1fe0034533c53c5c41761017065f85207a1b770483e98b2392315f6575e87"
  revision 2
  head "https://github.com/wbhart/flint2.git", :branch => "trunk"

  option "without-test", "Disable build-time checking (not recommended)"

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "ntl"
  stable do
    if OS.linux?
      patch :DATA
    end
  end
    
  def install
    ENV.append "CCFLAGS", "-std=c11"
    ENV.append "CXXFLAGS", "-std=c++11"
    system "./configure", "--prefix=#{prefix}",
                          "--with-gmp=#{Formula["gmp"].opt_prefix}",
                          "--with-mpfr=#{Formula["mpfr"].opt_prefix}",
                          "--with-ntl=#{Formula["ntl"].opt_prefix}"

    system "make"
    system "make", "install"
    system "make", "check" if build.with? "test"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <stdio.h>
      #include <gmp.h>

      #include <flint/flint.h>
      #include <flint/fmpz_mod_poly.h>

      int main(int argc, char* argv[])
      {
          fmpz_t n;
          fmpz_mod_poly_t x, y;

          fmpz_init_set_ui(n, 7);
          fmpz_mod_poly_init(x, n);
          fmpz_mod_poly_init(y, n);
          fmpz_mod_poly_set_coeff_ui(x, 3, 5);
          fmpz_mod_poly_set_coeff_ui(x, 0, 6);
          fmpz_mod_poly_sqr(y, x);
          fmpz_mod_poly_print(x); flint_printf("\\n");
          fmpz_mod_poly_print(y); flint_printf("\\n");
          fmpz_mod_poly_clear(x);
          fmpz_mod_poly_clear(y);
          fmpz_clear(n);

          return EXIT_SUCCESS;
      }
    EOS
    gmp = Formula["gmp"]
    system ENV.cc, "test.c", "-L#{gmp.opt_lib}", "-lgmp", "-L#{lib}","-lflint", "-o", "test"
    system "./test"
  end
end
__END__
diff --git a/Makefile.subdirs b/Makefile.subdirs
index ec05fb0..f2d8b37 100644
--- a/Makefile.subdirs
+++ b/Makefile.subdirs
@@ -59,7 +59,7 @@ $(BUILD_DIR)/$(MOD_DIR)_%.o: %.c
 	$(QUIET_CC) $(CC) $(CFLAGS) $(INCS) -c $< -o $@ -MMD -MP -MF "$(BUILD_DIR)/$(MOD_DIR)_$*.d" -MT "$(BUILD_DIR)/$(MOD_DIR)_$*.d" -MT "$@"

 $(MOD_LOBJ): $(LOBJS)
-	$(QUIET_CC) $(CC) $(ABI_FLAG) -Wl,-r $^ -o $@ -nostdlib
+	$(QUIET_CC) $(CC) $(ABI_FLAG) -r $^ -o $@ -nostdlib

 -include $(LOBJS:.lo=.d)
