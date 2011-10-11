<?php get_header(); ?>

  <div class='entry'>
   <h1>Archives</a>

   <ul>
    <?php wp_get_archives('type=monthly'); ?>
   </ul>
  </div>

<?php get_footer(); ?>
