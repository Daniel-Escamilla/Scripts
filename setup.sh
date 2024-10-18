#!/bin/bash

# Verifica que se haya proporcionado un argumento
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 <nombre_base>"
    exit 1
fi

BASE_NAME="$1"

# Crear carpetas
mkdir -p include
mkdir -p src
mkdir -p Z_To-Do_Z

# Crear el archivo de encabezado
cat <<EOL > "${BASE_NAME}.h"
#ifndef ${BASE_NAME}_H
# define ${BASE_NAME}_H

# include <stdio.h>
# include "libft/src/libft.h"  // Incluir la librería libft desde src

int ft_main(int c); // Declaración de la función ft_main

#endif // ${BASE_NAME}_H
EOL

# Crear el archivo main.c
cat <<EOL > src/main.c
#include "../${BASE_NAME}.h"

int main()
{
    printf("Aquí\n");
    return (0);
}
EOL

# Crear el archivo Makefile
cat <<EOL > Makefile
# Nombre del ejecutable
NAME = ${BASE_NAME}

# Compilador y flags
CC = gcc
CFLAGS = -g3 -Wall -Wextra -Werror

# Directorio de fuentes
SRC_DIR = src

# Archivos fuente
SRC = main.c

# Directorio de archivos objeto
OBJDIR = ${BASE_NAME}_objects
# Archivos objeto generados a partir de los archivos fuente
OBJS = \$(addprefix \$(OBJDIR)/, \$(SRC:.c=.o))

# Directorio de la libft
LIBFT_DIR = ./libft
LIBFT = \$(LIBFT_DIR)/libft.a

# Reglas
all: \$(OBJDIR) libft \$(NAME)

\$(OBJDIR):
	@mkdir -p \$@

\$(NAME): \$(OBJS) \$(LIBFT)
	\$(CC) \$(CFLAGS) -o \$@ \$^ \$(LIBFT)

\$(OBJDIR)/%.o: \$(SRC_DIR)/%.c | \$(OBJDIR)
	\$(CC) \$(CFLAGS) -c \$< -o \$@

libft:
	@make -sC \$(LIBFT_DIR) --no-print-directory

clean:
	rm -rf \$(OBJDIR)

fclean: clean
	rm -f \$(NAME)
	@make -sC \$(LIBFT_DIR) fclean

re: fclean all

run: Z_To-Do_Z/To-Do.py
	python3 Z_To-Do_Z/To-Do.py

.PHONY: all clean fclean re libft run
EOL

# Crear el archivo .gitignore en la raíz del proyecto
cat <<EOL > .gitignore
.vscode
${BASE_NAME}
${BASE_NAME}_objects/
libft_objects/
libft.a
EOL

# Crear la carpeta de libft y clonar la librería sin el historial git
git clone --depth 1 https://github.com/Daniel-Escamilla/Libft.git ./libft
rm -rf ./libft/.git  # Eliminar la carpeta .git

# Crear el archivo To-Do.py
cat <<EOL > Z_To-Do_Z/To-Do.py
#!/usr/bin/env python3
# To-Do list
def main():
    try:
        with open('Z_To-Do_Z/To-Do.txt', 'r') as file:
            tasks = file.readlines()
            for task in tasks:
                print(f"Ejecutando: {task.strip()}")
    except FileNotFoundError:
        print("El archivo To-Do.txt no fue encontrado.")

if __name__ == '__main__':
    main()
EOL

# Crear el archivo To-Do.txt dentro de Z_To-Do_Z vacío
touch Z_To-Do_Z/To-Do.txt

# Cambiar permisos para el script de Python
chmod +x Z_To-Do_Z/To-Do.py

# Mostrar mensaje de éxito
echo "Estructura de proyecto creada con éxito."

# Eliminar el script actual
rm -- "$0"
