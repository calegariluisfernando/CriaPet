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
        Schema::create('Especie', function (Blueprint $table) {
            $table->id();
            $table->string('nome', 45)->nullable(false);
            $table->timestamps();
        });

        Schema::table('Especie', function (Blueprint $table) {
            $table->unique('nome', 'idx_epecie_chave');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('Especie');
    }
};
