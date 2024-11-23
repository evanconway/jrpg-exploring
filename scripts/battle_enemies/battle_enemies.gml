function BattleEnemy() constructor {
	enemy_health = 100;
	sprite = spr_enemy;
	static get_width = function() {
		return sprite_get_width(sprite);
	};
	static draw = function(x, y) {
		draw_set_alpha(1);
		draw_sprite(sprite, 0, x, y);
	};
}

function BattleEnemyBig() : BattleEnemy() constructor {
	sprite = spr_enemy_big;
}
