<?php get_header(); ?>

  <?php if (have_posts()) : ?>
  <?php while (have_posts()) : the_post(); ?>
  <div class='entry'>
   <h1><a href='<?php the_permalink(); ?>'><?php the_title(); ?></a></h1>
   <div class='copy'>
    <?php the_content(); ?>
   </div>
   <p class='signoff'>written <a href='<?php the_time('0Y\/F\/j'); ?>'><?php the_time('j F, 0Y'); ?></a>
    • <a href='<?php the_permalink(); ?>#disqus_thread'>Comments</a>
    <a href='<?php the_permalink(); ?>' class='pilcrow' title='Permanent link to this entry'>⁋</a></p>
  <? endwhile; ?>
  </div>

  <div id='nextprev'>
   <span id='prevpage'><?php previous_posts_link('← Newer'); ?></span>
   <span id='nextpage'><?php next_posts_link('Older →'); ?></span>
  </div>
  <?php else : ?>
  <div class='entry'>
   <h1>Bzzzt!</h1>
   <p>Whatever you were looking for, this isn’t it.</p>
  </div>
  <?php endif; ?>

<?php get_footer(); ?>
