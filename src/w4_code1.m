plot(sine)
B = 1/10*ones(10, 1);
plot(filter(B, 1, sine));
plot(sine)
subplot(2, 1, 1);
plot(sine)
subplot(2, 1, 2);
plot(filter(B, 1, sine));
B = 1/5*ones(5, 1);
subplot(2, 1, 1);
subplot(2, 1, 2);
plot(filter(B, 1, sine));
B = 1/3*ones(3, 1);
plot(filter(B, 1, sine));
title('y(n)');
xlabel('amplitude');
ylabel('time');
subplot(2, 1, 1);
title('x(n)');
xlabel('amplitude');
ylabel('time');
ylabel('amplitude');
xlabel('time');
subplot(2, 1, 2);
xlabel('time');
ylabel('amplitude');
hold on
B = 1/4*ones(4,1);
plot(filter(B, 1, sine));
B = 1/5*ones(5,1);
plot(filter(B, 1, sine));
B = 1/6*ones(6,1);
plot(filter(B, 1, sine));
B = 1/7*ones(7,1);
plot(filter(B, 1, sine));
B = 1/8*ones(8,1);
plot(filter(B, 1, sine));
B = 1/9*ones(9,1);
plot(filter(B, 1, sine));
B = 1/10*ones(10,1);
plot(filter(B, 1, sine));
legend('$L=3$', '$L=4$', '$L=5$', '$L=6$', '$L=7$', '$L=8$', '$L=9$', '$L=10$')
legend('$L=3$', '$L=4$', '$L=5$', '$L=6$', '$L=7$', '$L=8$', '$L=9$', '$$L=10$$')
legend('$L=3$', '$L=4$', '$L=5$', '$L=6$', '$L=7$', '$L=8$', '$L=9$', '$L=10$','Interpreter','latex')
freqz([1, 0, 0, 0, 0, 0, 0, 0, -1], [1, -1]);
