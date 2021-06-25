FROM ubuntu:latest as initbuild
RUN apt-get update && \
    apt-get install -y python3-dev ccache python python3-pip chrpath docker.io upx
RUN pip3 install --upgrade pip nuitka

FROM initbuild as builder
COPY app /app
COPY build_scripts /build_scripts
RUN pip3 install -r app/requirements.txt
RUN nuitka3 --standalone --show-progress --python-flag=no_site app/app.py
RUN build_scripts/ldd_cp.sh "app.dist/app" "app.dist"
RUN ls -lhR app.dist
RUN cd /app.dist && rm *sqlite*.* _codec*.* _async*.so _bz2.so _crypt.so \
    _ctypes.so _curses.so _curses_panel.so _dbm.so _decimal.so \
    _hashlib.so _json.so _lsprof.so _lzma.so _multibytecodec.so \
    _opcode.so audioop.so libbz*.*  \
    libdb*.* libffi*.* liblz*.* libmp*.* libn*.* libpa*.*  \ 
    libre*.* libti*.* libuu*.* mmap.so readline.so termios.so
RUN upx --best --overlay=strip /app.dist/app

FROM scratch
COPY --from=builder /app.dist/ /
ENTRYPOINT ["./app"]
