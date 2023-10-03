<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('Animal', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('especie_id')->nullable();
            $table->string('nome', 45)->nullable(false);
            $table->string('raca', 45);
            $table->char('sexo', 1)->default('F');
            $table->decimal('peso', 4, 1);
            $table->dateTime('nascimento');
            $table->timestamps();
        });

        Schema::table('Animal', function (Blueprint $table) {
            $table->index('nome', 'idx_Animal_Nome');
            $table->foreign('especie_id', 'fk_Animal_Especie_idx')->references('id')->on('Especie');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('Animal', function (Blueprint $table) {
            $table->dropForeign('fk_Animal_Especie_idx');
            $table->dropIndex('idx_Animal_Nome');
        });

        Schema::dropIfExists('Animal');
    }
};
