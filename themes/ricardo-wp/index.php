<?php get_header(); ?>

  <div class='entry'>
  <?php if (have_posts()) : while (have_posts()) : the_post(); ?>
   <h1><a href='<?php the_permalink(); ?>'><?php the_title(); ?></a></h1>
   <div class='copy'>
    <?php the_content(); ?>
   </div>
  </div>
  <? endwhile; ?>

  <div id='nextprev'>
   <span id='prevpage'><?php previous_posts_link('← Newer'); ?></span>
   <span id='nextpage'><?php next_posts_link('Older →'); ?></span>
  </div>
  <?php else : ?>
   <h1>Bzzzt!</h1>
   <p>Whatever you were looking for, this isn’t it.</p>
  <?php endif; ?>
  </div>

<?php get_footer(); ?>
