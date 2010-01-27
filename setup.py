# build script for 'aqPython' - Python aqbanking wrapper (based on http://wiki.cython.org/PackageHierarchy)

import sys, os, stat, commands
from distutils.core import setup
from distutils.extension import Extension

# we'd better have Cython installed, or it's a no-go
try:
    from Cython.Distutils import build_ext
except:
    print "You don't seem to have Cython installed. Please get a"
    print "copy from www.cython.org and install it"
    sys.exit(1)

include_dirs = ["/usr/include/gwenhywfar3", "."]   # adding the '.' to include_dirs is CRUCIAL!!
libraries = ["aqbanking", "gwenhywfar"]

# scan the 'aqPython' directory for extension files, converting
# them to extension names in dotted notation
def scandir(dir, files=[]):
    for file in os.listdir(dir):
        path = os.path.join(dir, file)
        if os.path.isfile(path) and path.endswith(".pyx"):
            files.append(path.replace(os.path.sep, ".")[:-4])
        elif os.path.isdir(path):
            scandir(path, files)
    return files


# generate an Extension object from its dotted name
def makeExtension(extName):
    extPath = extName.replace(".", os.path.sep)+".pyx"
    return Extension(
        extName,
        [extPath],
        include_dirs=include_dirs,
#        extra_compile_args=["-O3", "-Wall"],
#        extra_link_args=['-g'],
        libraries=libraries,
        )

# get the list of extensions
extNames = scandir("aq")

# and build up the set of Extension objects
extensions = [makeExtension(name) for name in extNames]

# finally, we can pass all this to distutils
setup(
  name="aqPython",
  packages=["aq"],
  ext_modules=extensions,
  cmdclass = {'build_ext': build_ext},
)
