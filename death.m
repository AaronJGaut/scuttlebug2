birth_rate = 0.0005;
death_rate = 0.0005;
initial_pop = 100;
n=100;
steps = 6000;
plot_variance = false;


populations = zeros(n, steps+1);
populations(:,1) = initial_pop;

expected = @(t) initial_pop*exp((birth_rate-death_rate)*t);
variance = @(t) initial_pop*(exp(2*(birth_rate-death_rate)*t) - exp((birth_rate-death_rate)*t));
stddev = @(t) sqrt(variance(t));
for i = 1:steps
    for j = 1:n
        random = rand();
        birthChance = birth_rate*populations(j,i);
        deathChance = death_rate*populations(j,i);

        if birthChance + deathChance >= 1
           error('Too big');
        end

        random = random - birthChance;
        if random < 0
           populations(j,i+1) = populations(j,i) + 1;
        else
           random = random - deathChance;
           if random < 0
               populations(j,i+1) = populations(j,i) - 1;
           else
               populations(j,i+1) = populations(j,i);
           end
        end
    end
end

hold on
for i = 1:n
    hex = [rand(), rand(), rand()];
    plot(populations(i,:), 'color', hex);
end

t = 1:steps
plot(t, expected(t), 'k', 'linewidth', 3)

if plot_variance
    plot(t, expected(t)-variance(t), 'r', 'linewidth', 3)
    plot(t, expected(t)+variance(t), 'g', 'linewidth', 3)
end

hold off

axis([0 steps -inf inf])