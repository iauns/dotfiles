python
import sys
import gdb

#replace path
sys.path.insert(0, '/Users/jhughes/.gdb_printers/libcxx/python')   
#sys.path.insert(0, '/usr/local/share/gcc-4.6.2/python')
from libcxx.v1.printers import register_libcxx_printers
#from libstdcxx.v6.printers import register_libstdcxx_printers
register_libcxx_printers(None)
#register_libstdcxx_printers(None)
