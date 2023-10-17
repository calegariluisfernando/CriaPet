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
        Schema::create('Raca', function (Blueprint $table) {
            $table->id();
            $table->string('nome', 100);
            $table->unsignedBigInteger('especie_id');
            $table->timestamps();
        });

        Schema::table('Raca', function (Blueprint $table) {
            $table->foreign('especie_id', 'fk_Raca_especie_id')->references('id')->on('Especie');
        });

        Schema::table('Animal', function (Blueprint $table) {
            $table->dropColumn('raca');
            $table->unsignedBigInteger('raca_id')->after('especie_id')->nullable(false);
            $table->foreign('raca_id', 'fk_Animal_raca_id')->references('id')->on('Raca');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('Animal', function (Blueprint $table) {
            $table->dropForeign('fk_Animal_raca_id');
            $table->dropColumn('raca_id');
            $table->string('raca', 45);
        });
        Schema::dropIfExists('Raca');
    }
};
