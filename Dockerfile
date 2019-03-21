FROM jupyter/datascience-notebook:latest
MAINTAINER lele.cui@gmail.com

ENV YaHei_FONT_DIR="/usr/share/fonts/truetype/ms" \
    matplotlib_FONT_DIR="/opt/conda/lib/python3.7/site-packages/matplotlib/mpl-data/fonts/ttf" \
    matplotlibrc="/opt/conda/lib/python3.7/site-packages/matplotlib/mpl-data/matplotlibrc"

USER root
RUN mkdir ${YaHei_FONT_DIR} \
    && cd ${YaHei_FONT_DIR} \
    && wget -nv https://github.com/Cuile/cn-datascience-notebook/raw/master/fonts/YaHeiConsolas.ttf \
    && fc-cache -f -v

USER $NB_UID
RUN cp ${YaHei_FONT_DIR}/YaHeiConsolas.ttf ${matplotlib_FONT_DIR}/ \
    # && sed -i "s/#\(font.family.*\):.*/\1: monospace/" $matplotlibrc \
    && sed -i "s/#\(font.family.*\)/\1/" $matplotlibrc \
    # && sed -i "s/#\(font.monospace.*\):\(.*\)/\1: WenQuanYi Micro Hei Mono,\2/" ${matplotlibrc} \
    && sed -i "s/#\(font.sans-serif.*\):\(.*\)/\1: YaHei Consolas Hybrid,\2/" ${matplotlibrc} \
    && sed -i "s/#\(axes.unicode_minus.*\): True\(.*\)/\1: False\2/" ${matplotlibrc} \
    && rm -rf ~/.cache/matplotlib/