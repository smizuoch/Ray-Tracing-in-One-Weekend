NAME			=	inOneWeekend
CONTAINER		=	inOneWeekend
CC				=	c++
FLAGS			=	-Wall -Wextra -Werror
RM				=	rm -rf

SRCS_DIR		=	srcs/
INCS_DIR		=	includes/
OBJS_DIR		=	objs/

SRCS 			=   $(shell find $(SRCS_DIR) -type f -name "*.cpp")
HEADERS			=	$(wildcard $(INCS_DIR)*.h)
SHS				=	$(wildcard *.sh)
OBJS			=	$(patsubst %.cpp, $(OBJS_DIR)%.o, $(SRCS))

ifeq ($(MAKECMDGOALS), debug)
	FLAGS += -g -DDEBUG
endif

ifeq ($(MAKECMDGOALS), address)
	FLAGS += -g3 -fsanitize=address
endif

ifeq ($(MAKECMDGOALS), leaks)
	FLAGS += -g3 -fsanitize=address -fsanitize=leak
endif

all: $(NAME)

$(NAME): $(OBJS)
	$(CC) $(FLAGS) -I $(INCS_DIR) $(OBJS) -o $@

$(OBJS_DIR)%.o : %.cpp
	mkdir -p $(@D)
	$(CC) $(FLAGS) -I $(INCS_DIR) -c $< -o $@

image: all
	@./$(NAME) >> image.ppm

clean:
	$(RM) $(OBJS_DIR)

fclean: clean
	$(RM) $(NAME)
	$(RM) image.ppm

re:		fclean all

debug: re

address: re

leaks: re
	@echo "\033[1;33mRunning with LeakSanitizer...\033[0m"
	@echo "\033[0;34mNote: Export ASAN_OPTIONS=detect_leaks=1 before running the program\033[0m"
	@echo "Example: ASAN_OPTIONS=detect_leaks=1 ./$(NAME)"

.PHONY:	all clean fclean re up run down fmt debug address test coverage doc leaks