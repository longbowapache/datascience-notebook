FROM jupyter/datascience-notebook:latest

# 升级自带安装工具
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir --upgrade setuptools

# 安装Python库
RUN pip install --no-cache-dir \
    # 程序进度条库
    progressbar\ 
    # 数据库连接库
    mysql-connector-python\
    psycopg2-binary\
    # 配置文件读取
    pyhocon\
    # Python调试工具
    better-exceptions \
    PySnooper \
    # 网络请求
    requests\
    # 设备码计算
    check-device-code \
    # 绘图库
    wordcloud \
    plotly_express

ENV YaHei_FONT_DIR="/usr/share/fonts/truetype/ms" \
    matplotlib_FONT_DIR="/opt/conda/lib/python3.10/site-packages/matplotlib/mpl-data/fonts/ttf" \
    matplotlibrc="/opt/conda/lib/python3.10/site-packages/matplotlib/mpl-data/matplotlibrc"

USER root
RUN mkdir ${YaHei_FONT_DIR} \
    && cd ${YaHei_FONT_DIR} \
    && wget -nv https://github.com/Cuile/cn-datascience-notebook/raw/master/fonts/YaHeiConsolas.ttf \
    && fc-cache -f -v

# 修改时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezome

USER $NB_UID
RUN cp ${YaHei_FONT_DIR}/YaHeiConsolas.ttf ${matplotlib_FONT_DIR}/ \
    # && sed -i "s/#\(font.family.*\):.*/\1: monospace/" $matplotlibrc \
    && sed -i "s/#\(font.family.*\)/\1/" $matplotlibrc \
    # && sed -i "s/#\(font.monospace.*\):\(.*\)/\1: WenQuanYi Micro Hei Mono,\2/" ${matplotlibrc} \
    && sed -i "s/#\(font.sans-serif.*\):\(.*\)/\1: YaHei Consolas Hybrid,\2/" ${matplotlibrc} \
    && sed -i "s/#\(axes.unicode_minus.*\): True\(.*\)/\1: False\2/" ${matplotlibrc} \
    && rm -rf ~/.cache/matplotlib/

# 设置shell
RUN echo "export PS1='[\A \u@\H \w]\\$ '" >> $HOME/.bashrc \
    && echo "alias ll='ls -lh --color'" >> $HOME/.bashrc