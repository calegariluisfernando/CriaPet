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
        Schema::create('UserPhoto', function (Blueprint $table) {
            $table->id();
            $table->string('url', 500);
            $table->unsignedBigInteger('user_id');
            $table->timestamps();

            $table->foreign('user_id', 'fkUserPhoto_user_id_foreign_user')
                ->references('id')
                ->on('users')
                ->cascadeOnDelete()
                ->cascadeOnUpdate();

            $table->unique('user_id', 'idx_chave_user');
        });

        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn('photo');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('photo', 255);
        });

        Schema::table('UserPhoto', function (Blueprint $table) {
            $table->dropForeign('fkUserPhoto_user_id_foreign_user');
        });
        Schema::dropIfExists('UserPhoto');
    }
};
